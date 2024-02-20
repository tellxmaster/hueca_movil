import 'package:flutter/material.dart';
import 'package:hueca_movil/user_auth/presentation/pages/sign_up_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, SignUpPage.routeName);
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/logo.png'),
              width: 300.0,
              height: 300.0,
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              color: Colors.blue,
            ), // Circular Progress Indicator
          ],
        ),
      ),
    );
  }
}
