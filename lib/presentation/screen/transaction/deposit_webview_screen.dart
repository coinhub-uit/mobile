import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:webview_flutter/webview_flutter.dart";
import "package:coinhub/core/bloc/deposit/deposit_logic.dart";

class DepositWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String topUpId;

  const DepositWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.topUpId,
  });

  @override
  State<DepositWebViewScreen> createState() => _DepositWebViewScreenState();
}

class _DepositWebViewScreenState extends State<DepositWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar if needed
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });

                // Check if the URL indicates a return to the app
                if (url.contains("coinhub://home")) {
                  // Payment flow completed, check status
                  context.read<DepositBloc>().add(
                    DepositWebViewClosed(widget.topUpId),
                  );
                  Navigator.of(context).pop();
                }
              },
              onNavigationRequest: (NavigationRequest request) {
                // Handle custom scheme redirects
                if (request.url.startsWith("coinhub://")) {
                  // Payment flow completed, check status
                  context.read<DepositBloc>().add(
                    DepositWebViewClosed(widget.topUpId),
                  );
                  Navigator.of(context).pop();
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Payment",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // User manually closed the webview, check status
            context.read<DepositBloc>().add(
              DepositWebViewClosed(widget.topUpId),
            );
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
