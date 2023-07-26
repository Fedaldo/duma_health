import 'package:duma_health/utils/enumeration.dart';
import 'package:duma_health/widgets/bg_custom_paint.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatelessWidget {
  final String nextPath;

  const AuthScreen({Key? key, required this.nextPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(w, (w * 1.6).toDouble()),
            painter: BgCustomPainter(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Hero(
                      tag: 'doc',
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.png',
                          height: h / 6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: w / 1.2,
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 2,
                      color: Colors.black87,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            "Make an appointment with doctors or buy medicine from our local pharmacies with ",
                      ),
                      TextSpan(
                          text: "DUMA ",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            letterSpacing: 0,
                          )),
                      TextSpan(
                        text: "Health",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          letterSpacing: 0,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 30,
            left: 30,
            child: Column(
              children: [
                SizedBox(
                  width: w,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/${RouterPath.signIn}', extra: nextPath);
                    },
                    child: Text(
                      'Log In'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, letterSpacing: 3),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: w,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/${RouterPath.signUp}', extra: nextPath);
                    },
                    child: Text(
                      "Create an account".toUpperCase(),
                      style: const TextStyle(letterSpacing: 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
