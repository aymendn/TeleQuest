import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasa/core/app_route.dart';
import 'package:nasa/providers/questions.dart';
import 'package:nasa/widgets/answer_card.dart';
import 'package:nasa/widgets/custom_button.dart';

import '../widgets/custom_timer.dart';

class OfflineGameScreen extends ConsumerWidget {
  const OfflineGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);

    ref.listen<Questions>(questionsProvider, (previous, next) {
      if (next.isFinish || next.seconds == 0) {
        Navigator.of(context).pushReplacementNamed(AppRoute.finishLevel);
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
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'level ${(questions.currentLevel ?? 0) + 1}',
                      style: const TextStyle(
                        color: Color(0xff37EBBC),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const CustomTimer(leftSeconds: 20),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: Text(
                      'Question ${questions.currentQuestionIndex + 1}/4',
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
                            questions.currentQuestion.question,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                           if (questions.currentQuestion.image != null)
                            Image.asset(
                                'assets/t-images/${questions.currentQuestion.image}'),
                          for (int i = 0;
                              i < questions.currentAnswers.length;
                              i++)
                            AnswerCard(
                              answer: questions.currentAnswers[i],
                              answerCardStatus: questions.answersStatus[i],
                              onTap: questions.isChoseAnswer
                                  ? null
                                  : () {
                                      questions.chooseAnswer(i);
                                    },
                            ),
                          if (questions.isChoseAnswer) ...[
                            const SizedBox(height: 20),
                            CustomButton(
                              padding: 0,
                              onPressed: questions.nextQuestion,
                              text: 'Next Question',
                            ),
                          ]
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
}
