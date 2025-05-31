import "dart:async";
import "package:flutter/widgets.dart";
import "package:coinhub/core/services/local_storage.dart";

class TimeoutService extends ChangeNotifier with WidgetsBindingObserver {
  static final TimeoutService _instance = TimeoutService._internal();
  factory TimeoutService() => _instance;
  TimeoutService._internal();

  DateTime? _lastActivityTime;
  bool _isLocked = false;
  bool _isInitialized = false;

  final LocalStorageService _storage = LocalStorageService();

  // Default timeout duration in minutes
  static const int _defaultTimeoutMinutes = 5;

  bool get isLocked => _isLocked;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    WidgetsBinding.instance.addObserver(this);
    _lastActivityTime = DateTime.now();
    _isInitialized = true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<int> getTimeoutMinutes() async {
    try {
      final timeoutStr = await _storage.read("auto_lock_timeout");
      return int.tryParse(timeoutStr ?? "") ?? _defaultTimeoutMinutes;
    } catch (e) {
      return _defaultTimeoutMinutes;
    }
  }

  Future<void> setTimeoutMinutes(int minutes) async {
    try {
      await _storage.write("auto_lock_timeout", minutes.toString());
    } catch (e) {
      debugPrint("Error setting timeout: $e");
    }
  }

  void recordActivity() {
    if (!_isInitialized) return;

    _lastActivityTime = DateTime.now();

    // Unlock if currently locked due to user activity
    if (_isLocked) {
      _unlock();
    }
  }

  // Simple check: is elapsed time > timeout duration?
  Future<bool> shouldLock() async {
    // Must have authentication enabled
    if (!await _isAuthenticationEnabled()) {
      return false;
    }

    // Must have valid last activity time
    if (_lastActivityTime == null) {
      return false;
    }

    final timeoutMinutes = await getTimeoutMinutes();
    final elapsed = DateTime.now().difference(_lastActivityTime!);
    final shouldLock = elapsed > Duration(minutes: timeoutMinutes);

    return shouldLock;
  }

  // Check and trigger lock if needed
  Future<void> checkAndLock() async {
    if (await shouldLock() && !_isLocked) {
      _triggerLock();
    }
  }

  void _triggerLock() {
    _isLocked = true;
    notifyListeners();
  }

  void _unlock() {
    _isLocked = false;
    _lastActivityTime = DateTime.now();
    notifyListeners();
  }

  Future<void> unlock() async {
    _unlock();
  }

  Future<bool> _isAuthenticationEnabled() async {
    try {
      final pinEnabled = await _storage.read("pin_enabled") == "true";
      final fingerprintEnabled =
          await _storage.read("fingerprint_enabled") == "true";
      final faceIdEnabled = await _storage.read("face_id_enabled") == "true";

      final result = pinEnabled || fingerprintEnabled || faceIdEnabled;
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Check if we should lock when app resumes
        checkAndLock();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // No special handling needed - time keeps ticking
        break;
    }
  }

  // Force lock for testing
  Future<void> forceLock() async {
    if (await _isAuthenticationEnabled()) {
      _triggerLock();
    } else {}
  }

  // Get remaining time until timeout
  Future<Duration?> getRemainingTime() async {
    if (_isLocked ||
        _lastActivityTime == null ||
        !await _isAuthenticationEnabled()) {
      return null;
    }

    final timeoutMinutes = await getTimeoutMinutes();
    final timeoutDuration = Duration(minutes: timeoutMinutes);
    final elapsed = DateTime.now().difference(_lastActivityTime!);
    final remaining = timeoutDuration - elapsed;

    return remaining.isNegative ? Duration.zero : remaining;
  }

  // Check if timeout should be enabled
  Future<bool> isTimeoutEnabled() async {
    return await _isAuthenticationEnabled();
  }
}
