// Step 10: Error Screens (widgets/error_screens/no_internet_screen.dart)
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoInternetScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'No Internet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Please check your internet connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                if (onRetry != null) {
                  onRetry!();
                }
                Navigator.pop(context);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Similarly for ServerErrorScreen (widgets/error_screens/server_error_screen.dart)
class ServerErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  const ServerErrorScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          // leading: SizedBox(),
          centerTitle: true,
          title: const Text(
            'Server Error',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Something went wrong on the server. \nPlease try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                if (onRetry != null) {
                  onRetry!();
                }
                Navigator.pop(context);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
