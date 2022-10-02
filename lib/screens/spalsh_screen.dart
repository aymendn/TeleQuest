import 'package:flutter/material.dart';
import 'package:nasa/core/app_route.dart';
import 'package:nasa/widgets/wave.dart';

import '../widgets/custom_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff362679),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                ),
                const SizedBox(height: 10),
                const Text(
                  'TeleQuest',
                  style: TextStyle(
                    color: Color(0xff37EBBC),
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Wave(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xff1F1147),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'New knowledge, new friends',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'play now and level up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white60,
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'get Started',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoute.welcome);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
