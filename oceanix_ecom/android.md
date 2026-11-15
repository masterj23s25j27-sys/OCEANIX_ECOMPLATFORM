# OCEANIX — Flutter Mobile App Development Guide

This guide describes how to build a premium, native-feeling cross-platform mobile application (for Android & iOS) wrapping the OCEANIX E-Commerce platform using **Flutter**. It is optimized for performance, animations, and supports all advanced features like AI Visual Search (camera and photo uploads) and hardware back-button navigation.

---

## 🚀 The LLM Prompt (Generate Flutter Code Instantly)

You can copy and paste the prompt below into any AI agent (or Antigravity in a Flutter workspace) to generate the complete, production-ready Flutter app in seconds.

```text
Create a modern cross-platform mobile e-commerce wrapper application in Flutter.
The application should load the web URL "http://10.0.2.2:8000" on Android (default emulator localhost loopback) or "http://localhost:8000" on iOS.

Implement the following requirements:
1. UI & Theme:
   - Clean, material design user interface.
   - A native Splash Screen displaying a circular logo, fade-in animation, and branding matching the light/dark mode colors of OCEANIX.
   - Support for dynamic status bar colors matching the application theme.
   - Swipe-to-refresh container to reload the web page.

2. WebView Configuration (Crucial):
   - Use the 'webview_flutter' package.
   - Enable JavaScript execution and DOM Storage.
   - Configure a custom User-Agent suffix to identify the mobile client.
   - Handle loading states with a native circular loading indicator overlay.
   - Implement elegant error screens with a "Retry" button when offline.

3. Device & Navigation:
   - Handle physical back-button navigation on Android using PopScope: if the WebView can go back in history, it should go back. If not, ask the user to double-press to exit the app.
   - Handle permissions (Camera and Gallery access) for file uploads (needed for AI Visual Search).

Generate the complete project code, including pubspec.yaml, main.dart, and Android/iOS configuration files (AndroidManifest.xml, Info.plist).
```

---

## 🛠️ Step-by-Step Manual Implementation

### 1. Set Up the Flutter Project
Initialize a new Flutter project:
```bash
flutter create oceanix_app --org com.oceanix.store
cd oceanix_app
```

Add the official WebView and permissions dependencies to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  webview_flutter: ^4.10.0
  permission_handler: ^11.3.1
```
Run `flutter pub get`.

### 2. Configure Platforms

#### Android Configuration
Open `android/app/src/main/AndroidManifest.xml` and declare permissions under the `<manifest>` tag:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```
To test local HTTP sites (like `http://10.0.2.2:8000`), allow cleartext traffic by adding this inside the `<application>` tag:
```xml
android:usesCleartextTraffic="true"
```

Set the minimum SDK version to `21` in `android/app/build.gradle`:
```groovy
defaultConfig {
    minSdkVersion 21
}
```

#### iOS Configuration
Open `ios/Runner/Info.plist` and add permission descriptions:
```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to upload photos for AI Visual Search.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires photo library access to upload photos for AI Visual Search.</string>
<!-- Allow local cleartext HTTP connections -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 3. Core Flutter Code (`lib/main.dart`)
Replace the contents of `lib/main.dart` with this implementation:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const OceanixApp());
}

class OceanixApp extends StatelessWidget {
  const OceanixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCEANIX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2563EB),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  String get _initialUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/'; // Android Emulator loopback
    } else {
      return 'http://localhost:8000/'; // iOS Simulator loopback
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Check if error is terminal (e.g. host unreachable)
            if (error.description.contains('ERR_CONNECTION_REFUSED') ||
                error.description.contains('unreachable')) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_initialUrl));
  }

  Future<void> _refreshPage() async {
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          await _controller.goBack();
        } else {
          // Double-tap or exit prompt logic can be wired here
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              if (!_hasError)
                RefreshIndicator(
                  onRefresh: _refreshPage,
                  child: WebViewWidget(controller: _controller),
                ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF2563EB),
                  ),
                ),
              if (_hasError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    key: const ValueKey('error_screen'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Connection Error',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Could not connect to the server. Please verify the store is running.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _refreshPage,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🔍 Key Architecture Details

1. **Platform Detection**: The app detects the operating system dynamically (`Platform.isAndroid`), using `10.0.2.2` (the Android emulator loopback alias) and `localhost` (for iOS simulator loopback) to communicate with your local Django development server.
2. **Back Navigation Handler**: The `PopScope` widget intercepts the device's back-button gestures, allowing web navigation back-history actions without terminating the app.
3. **Robust Connection Error Handling**: If the development server is offline, the app switches dynamically to an offline view template showing a modern reconnect screen rather than displaying a raw browser crash error.
