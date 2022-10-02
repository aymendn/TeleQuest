import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nasa/core/app_route.dart';
import 'package:nasa/providers/offline.dart';

import '../widgets/answer_card.dart';
import '../widgets/custom_button.dart';

class OfflineMultiplayerScreen extends ConsumerWidget {
  const OfflineMultiplayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(offlineProvider);

    ref.listen<Offline>(offlineProvider, (previous, next) {
      if (next.isFinish) {
        Navigator.of(context)
            .pushReplacementNamed(AppRoute.offlineMultiplayerResult);
      }
    });
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
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SvgPicture.asset(
                'assets/images/circles.svg',
                fit: BoxFit.fitHeight,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildUserCard(1, offline.userScore),
                        const SizedBox(width: 20),
                        const Text(
                          'VS',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(width: 30),
                        _buildUserCard(2, offline.enemyScore),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: Text(
                      'Question ${offline.currentQuestionIndex + 1}/10',
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: ListView(
                        children: [
                          Text(
                            offline.currentQuestion.question,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          if (offline.currentQuestion.image != null)
                            Image.asset(
                                'assets/t-images/${offline.currentQuestion.image}'),
                          for (int i = 0;
                              i < offline.currentAnswers.length;
                              i++)
                            AnswerCard(
                              answer: offline.currentAnswers[i],
                              answerCardStatus: offline.answersStatus[i],
                              onTap: offline.isUserAnswering == null ||
                                      offline.isChoseAnswer
                                  ? null
                                  : () {
                                      offline.answerQuestion(i);
                                    },
                            ),
                          if (offline.isChoseAnswer) ...[
                            const SizedBox(height: 20),
                            CustomButton(
                              padding: 0,
                              onPressed: offline.nextQuestion,
                              text: 'Next Question',
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                HandButton(
                                  color: Color(0xff189AFE),
                                  isUser: true,
                                ),
                                HandButton(
                                  color: Color(0xff16968B),
                                  isUser: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildUserCard(int user, int score) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text(
                'USER $user',
                style: const TextStyle(color: Colors.black87, fontSize: 22),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black54,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                score.toString(),
                style: const TextStyle(color: Colors.black87, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HandButton extends ConsumerWidget {
  const HandButton({
    required this.color,
    required this.isUser,
    Key? key,
  }) : super(key: key);

  final Color color;
  final bool isUser;

  @override
  Widget build(BuildContext context, ref) {
    final offline = ref.watch(offlineProvider);
    return InkWell(
      onTap: offline.isUserAnswering != null
          ? null
          : () {
              offline.chooseAnswerer(isUser);
            },
      child: CircleAvatar(
        backgroundColor: color.withOpacity((offline.isUserAnswering != null &&
                offline.isUserAnswering != isUser)
            ? .4
            : 1),
        radius: 50,
        child: SvgPicture.asset('assets/images/hand.svg'),
      ),
    );
  }
}

// getOpacity(bool? isAnswering, bool isUser) {
//   if (isAnswering != null && !isUser) {
//     return .4;
//   }
//   return 1;
// }
