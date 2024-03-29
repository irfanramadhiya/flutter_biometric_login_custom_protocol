import 'package:esafx/pages/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((isSupported) => setState(() {
          _supportState = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome, please login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_supportState)
              const Text("This device is supported for biometrics")
            else
              const Text("This device is not supported for biometrics"),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: _authenticateBiometrics,
                child: const Text("Authenticate and go to webview")),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: navigateToWebView,
                child: const Text("Go to webview")),
            // const SizedBox(
            //   height: 32,
            // ),
            // ElevatedButton(
            //     onPressed: launchSecondApp,
            //     child: const Text("Go to another app"))
          ],
        ),
      ),
    );
  }

  Future<void> _authenticateBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: "login",
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true));

      if (authenticated) {
        navigateToWebView();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  navigateToWebView() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const WebViewPage()));
  }

  // Future<void> launchSecondApp() async {
  //   String secondAppUrl = "https://esafx.com/";
  //   if (!await launchUrl(Uri.parse(secondAppUrl))) {
  //     throw Exception('Could not launch $secondAppUrl');
  //   }
  // }
}
