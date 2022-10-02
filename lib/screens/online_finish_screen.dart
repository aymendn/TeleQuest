import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../providers/online.dart';
import '../widgets/custom_button.dart';

class OnlineFinishScreen extends ConsumerWidget {
  const OnlineFinishScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.read(roomProvider);

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
                padding: EdgeInsets.all(8.0),
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
                'You\'ve done a great job!',
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
                          Text(
                            room.isWinner
                                ? 'YOU WON!! CONGRATS'
                                : 'You lose :(',
                            style: const TextStyle(fontSize: 23),
                          ),
                          const Divider(thickness: 3),
                          const Text(
                            'Winner:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          ClipOval(
                            child: room.isWinner
                                ? Image.network(
                                    room.user.profilePicture,
                                    width: 100,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.redAccent,
                                    radius: 50,
                                    child: Text(
                                      room.winner![0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            room.winner!,
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
                onPressed: () async {
                  Navigator.pop(context);
                  await room.endRoom();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
