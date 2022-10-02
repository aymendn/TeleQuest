import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../providers/offline.dart';
import '../widgets/custom_button.dart';

class OfflineMultiplayerResultScreen extends ConsumerWidget {
  const OfflineMultiplayerResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(offlineProvider);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1F1147), Color(0xff362679)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Result',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xff37EBBB),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                'You both have done a great job!',
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                'Let\'s take a look at the resutls:',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff37EBBB),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xff7A5CFB), Color(0xff44348C)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -5,
                      left: -5,
                      right: -5,
                      child: SvgPicture.asset(
                        'assets/images/score-circles.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'THE WINNER IS...',
                            style: TextStyle(fontSize: 23),
                          ),
                          const Divider(thickness: 3),

                          const SizedBox(height: 10),
                          Text(
                            offline.isWinner ? 'User1' : 'User2',
                            style: const TextStyle(fontSize: 18),
                          ),
                          // const ScoreCard(score: 20, stars: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                padding: 0,
                text: 'Home Page',
                onPressed: () {
                  Navigator.pop(context);
                  offline.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
