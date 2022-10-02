import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nasa/core/app_route.dart';
import 'package:nasa/providers/online.dart';

import '../widgets/answer_card.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  var answeredList = List.generate(7, (index) => false);
  var index = 0;

  @override
  void initState() {
    super.initState();
    final room = ref.read(roomProvider);
    final roomRef = FirebaseDatabase.instance.ref('rooms/${room.roomName}');

    roomRef.onValue.listen((DatabaseEvent event) {
      final roomAsMap = event.snapshot.value;
      final list =
          List<String>.generate(7, (index) => (roomAsMap! as Map)['q$index']);
      room.updateQuestions(list);

      print(room.questions);

      if ((roomAsMap! as Map)['q${room.currentQuestionIndex}'] ==
              room.enemyUserName &&
          !room.isMyFault) {
        room.answerQuestionByEnemy(true);
      }

      if ((roomAsMap as Map)['q${room.currentQuestionIndex}'] ==
              room.user.username &&
          !room.amIRight) {
        room.answerQuestionByEnemy(false);
      }

      if (room.isDone) {
        Navigator.of(context).pushReplacementNamed(AppRoute.onlineFinish);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(roomProvider);
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
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(room.user.profilePicture),
                          ),
                          title: Text(
                            'Score: ${room.userScore}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(room.user.username ?? '',
                                style: const TextStyle(color: Colors.green)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            radius: 20,
                            child: Text(
                              room.winner![0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            'Score: ${room.enemyScore}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              room.enemyUserName ?? '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 10,
                    alignment: room.alignment,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xff8165FF), Color(0xff37EBBC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: Text(
                      'Question ${room.currentQuestionIndex + 1}/7',
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
                        border: Border.all(width: 4, color: room.borderColor),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: ListView(
                        children: [
                          Text(
                            room.currentQuestion.question,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          if (room.currentQuestion.image != null)
                            Image.asset(
                                'assets/t-images/${room.currentQuestion.image}'),
                          for (int i = 0; i < room.currentAnswers.length; i++)
                            AnswerCard(
                              answer: room.currentAnswers[i],
                              answerCardStatus: room.answersStatus[i],
                              onTap: room.isAnswerChosen
                                  ? null
                                  : () async {
                                      await ref
                                          .read(roomProvider.notifier)
                                          .answerQuestion(i);
                                    },
                            ),
                          const SizedBox(height: 10),
                          if (room.isRightAnswer == false)
                            const Text(
                              'Wrong Answer!!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                              ),
                            ),
                          if (room.isRightAnswer == true)
                            const Text(
                              'Right Answer!!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Game screen')),
      body: ListView(
        children: [
          Center(
              child: Text(
                  'player 1 : ${room.room!.user1}, player 2 : ${room.user2}')),
          Text(room.currentQuestion.question),
          for (int i = 0; i < room.currentQuestion.answersList.length; i++)
            ElevatedButton(
              onPressed: () async {
                await ref.read(roomProvider.notifier).answerQuestion(i);
              },
              child: Text(room.currentQuestion.answersList[i]),
            ),
        ],
      ),
    );
  }
}
