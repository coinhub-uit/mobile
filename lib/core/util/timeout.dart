import "dart:async";

import "package:flutter/material.dart";
import "package:coinhub/core/services/timeout_service.dart";
import "package:coinhub/presentation/screen/auth/unlock_screen.dart";

class Timeout extends StatefulWidget {
  final Widget child;
  final VoidCallback? onInactivityTimeout;

  const Timeout({super.key, required this.child, this.onInactivityTimeout});

  @override
  TimeoutState createState() => TimeoutState();
}

class TimeoutState extends State<Timeout> with WidgetsBindingObserver {
  final TimeoutService _timeoutService = TimeoutService();
  Timer? _checkTimer;
  bool _isShowingUnlockScreen = false;

  void _handleUserInteraction([_]) {
    _timeoutService.recordActivity();
  }

  @override
  void initState() {
    super.initState();
    _initializeTimeoutService();
    _startPeriodicCheck();
  }

  Future<void> _initializeTimeoutService() async {
    await _timeoutService.initialize();
  }

  void _startPeriodicCheck() {
    // Check every 30 seconds if we should lock
    _checkTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      await _timeoutService.checkAndLock();

      // Update UI state based on lock status
      if (_timeoutService.isLocked && !_isShowingUnlockScreen) {
        setState(() {
          _isShowingUnlockScreen = true;
        });
        widget.onInactivityTimeout?.call();
      } else if (!_timeoutService.isLocked && _isShowingUnlockScreen) {
        setState(() {
          _isShowingUnlockScreen = false;
        });
      }
    });
  }

  void _onUnlockSuccess() {
    setState(() {
      _isShowingUnlockScreen = false;
    });
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isShowingUnlockScreen) {
      // Wrap the unlock screen in Material context to provide proper theming and directionality
      return MaterialApp(
        home: UnlockScreen(onSuccess: _onUnlockSuccess),
        theme: Theme.of(context), // Use the current app theme
        debugShowCheckedModeBanner: false,
      );
    }

    return Listener(
      onPointerDown: _handleUserInteraction,
      onPointerMove: _handleUserInteraction,
      onPointerUp: _handleUserInteraction,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
