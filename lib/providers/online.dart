import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nasa/models/game_user.dart';
import 'package:nasa/models/question.dart';
import 'package:nasa/providers/auth.dart';

import '../data/questions_data.dart';
import '../models/room.dart';
import 'questions.dart';

// final roomProvider = StateNotifierProvider<RoomNotifier, Room?>((ref) {
//   return RoomNotifier(ref.watch(authProvider.notifier).user);
// });

final roomProvider = ChangeNotifierProvider<RoomNotifier>((ref) {
  return RoomNotifier(ref.watch(authProvider.notifier).user);
});

class RoomNotifier extends ChangeNotifier {
  RoomNotifier(this.user);
  final GameUser user;

  Room? room;
  List questions = ['', '', '', '', '', '', ''];
  int currentQuestionIndex = 0;
  bool isMyFault = false;
  bool amIRight = false;
  bool isAnswerChosen = false;
  bool? isUserAnswering;

  bool? isRightAnswer;

  Alignment get alignment {
    switch (isUserAnswering) {
      case true:
        return Alignment.centerLeft;
      case false:
        return Alignment.centerRight;

      default:
        return Alignment.center;
    }
  }

  Color get borderColor {
    switch (isRightAnswer) {
      case true:
        return Colors.green;
      case false:
        return Colors.redAccent;

      default:
        return Colors.white;
    }
  }

  bool get isWinner => userScore > enemyScore;

  String? get winner => isWinner ? user.username : enemyUserName;

  Question get currentQuestion => questionsList[currentQuestionIndex];

  List<String> get currentAnswers => currentQuestion.answersList;

  List<Question> get questionsList =>
      questionsData.sublist(0, 7).map((q) => Question.fromMap(q)).toList();

  List<AnswerCardStatus> get answersStatus {
    if (isAnswerChosen) {
      return List.generate(currentAnswers.length, (index) {
        if (index == currentQuestion.rightAnswerIndex - 1) {
          return AnswerCardStatus.right;
        }
        return AnswerCardStatus.disabled;
      });
    } else {
      return List.generate(currentAnswers.length, (index) {
        return AnswerCardStatus.normal;
      });
    }
  }

  bool get isDone => !questions.contains('');

  bool get isCurrentQuestionAnswered => questions[currentQuestionIndex] != '';

  String? get user1 => room?.user1;
  String? get user2 => room?.user2;
  String? get roomName => room?.roomName;

  String? get enemyUserName => user1 != user.username ? user1 : user2;

  int get userScore {
    int score = 0;
    for (var ans in questions) {
      if (ans == user.username) score++;
    }
    return score;
  }

  int get enemyScore {
    int score = 0;
    for (var ans in questions) {
      if (ans == enemyUserName) score++;
    }
    return score;
  }

  void answerQuestionByEnemy(bool isRight) async {
    isUserAnswering = false;
    isAnswerChosen = true;
    isRightAnswer = isRight;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    isUserAnswering = null;
    isAnswerChosen = false;
    isRightAnswer = null;
    if (currentQuestionIndex < 6) currentQuestionIndex++;
    questions[currentQuestionIndex] = isRight ? enemyUserName : user.username;
    notifyListeners();
  }

  updateQuestions(List<String> list) {
    questions = list;
  }

  Future<void> answerQuestion(int index) async {
    final isRightAns = currentQuestion.rightAnswerIndex - 1 == index;

    isUserAnswering = true;
    isAnswerChosen = true;
    isRightAnswer = isRightAns;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    isUserAnswering = null;
    final database = FirebaseDatabase.instance.ref();
    final roomRef = database.child('rooms/${room?.roomName}');
    if (isRightAns) {
      amIRight = true;
      await roomRef.update({'q$currentQuestionIndex': user.username});
      questions[currentQuestionIndex] = user.username;
    } else {
      isMyFault = true;
      await roomRef.update({'q$currentQuestionIndex': enemyUserName});
      questions[currentQuestionIndex] = enemyUserName;
    }

    if (currentQuestionIndex < 6) currentQuestionIndex++;
    isMyFault = false;
    amIRight = false;
    isAnswerChosen = false;
    isRightAnswer = null;
    notifyListeners();
  }

  void addSecondUser(roomAsMap) {
    // setRoom(user1: roomAsMap['user1']);

    if (roomAsMap['user1'] == user.username) {
      room!.user2 = roomAsMap['user2'];
    }

    if (roomAsMap['user2'] == user.username) {
      room!.user1 = roomAsMap['user1'];
    }

    notifyListeners();
  }

  Future<void> endRoom() async {
    if (room!.roomName == null) return;
    final database = FirebaseDatabase.instance.ref();
    final leaderBoardRef = database.child('rooms/${room!.roomName}');
    await leaderBoardRef.update({
      'user1': '',
      'user2': '',
      'q0': '',
      'q1': '',
      'q2': '',
      'q3': '',
      'q4': '',
      'q5': '',
      'q6': '',
    });

    isUserAnswering = null;
    questions = ['', '', '', '', '', '', ''];
    currentQuestionIndex = 0;
    room = null;
    notifyListeners();
  }

  Future<void> joinRoom() async {
    room = Room();
    final database = FirebaseDatabase.instance.ref();
    final url = Uri.parse(
        'https://nasa-petacode-default-rtdb.firebaseio.com/rooms.json');

    final response = await http.get(url);

    if (json.decode(response.body) == null) {
      room!.roomName = 'room1';
      // setRoom(roomName: 'room1');
      return;
    }

    final extractedRooms =
        Map<String, dynamic>.from(json.decode(response.body));

    for (var entry in extractedRooms.entries) {
      final roomName = entry.key;
      final roomAsMap = entry.value;
      if (roomAsMap['user1'] == '') {
        // state = state!.copyWith(roomName: roomName);
        room!.roomName = roomName;

        final leaderBoardRef = database.child('rooms/$roomName');
        await leaderBoardRef.update({'user1': user.username});

        // setRoom(user1: user.username);
        room!.user1 = user.username;

        break;
      } else {
        // setRoom(user1: roomAsMap['user1']);
        room!.user1 = roomAsMap['user1'];
      }

      if (roomAsMap['user2'] == '') {
        // state = state!.copyWith(roomName: roomName);
        room!.roomName = roomName;

        final leaderBoardRef = database.child('rooms/$roomName');
        await leaderBoardRef.update({'user2': user.username});

        // setRoom(user2: user.username);
        room!.user2 = user.username;

        break;
      } else {
        // setRoom(user2: roomAsMap['user2']);
        room!.user2 = roomAsMap['user2'];
      }
    }
    room!.roomName ??= 'room1';
    print(room!.roomName);
    notifyListeners();
  }
}
