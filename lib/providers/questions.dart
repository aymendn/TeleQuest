import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa/data/questions_data.dart';
import 'package:nasa/models/game_user.dart';
import 'package:nasa/models/question.dart';
import 'package:nasa/providers/auth.dart';

enum AnswerCardStatus {
  normal,
  disabled,
  error,
  right,
}

final questionsProvider = ChangeNotifierProvider<Questions>((ref) {
  return Questions(ref.watch(authProvider).user);
});

class Questions extends ChangeNotifier {
  Questions(this.user);
  final GameUser user;
  int? currentLevel;
  int currentQuestionIndex = 0;
  int? currentQuestionAnswerIndex;
  int rightAnswers = 0;
  bool isFinish = false;
  int? currentScore;

  Timer? timer;
  int seconds = 60;

  Question get currentQuestion =>
      questions[currentLevel! * 4 + currentQuestionIndex];

  List<int> ratings = List.generate(24, (index) => 0);

  int get currentRating => ratings[currentLevel ?? 0];

  List<String> get currentAnswers => currentQuestion.answersList;

  Timer? questionTimer;
  List<Question> questions =
      questionsData.map((q) => Question.fromMap(q)).toList();
  int get currentUserLevel => user.offlineLevel;

  bool get isChoseAnswer => answersStatus.contains(AnswerCardStatus.right);

  List<AnswerCardStatus> get answersStatus {
    if (currentQuestionAnswerIndex == null) {
      return List.generate(currentQuestion.answersList.length,
          (index) => AnswerCardStatus.normal);
    } else if (currentQuestionAnswerIndex ==
        currentQuestion.rightAnswerIndex - 1) {
      return List.generate(currentQuestion.answersList.length, (index) {
        if (index == currentQuestionAnswerIndex) {
          return AnswerCardStatus.right;
        }
        return AnswerCardStatus.disabled;
      });
    } else {
      return List.generate(currentQuestion.answersList.length, (index) {
        if (index == currentQuestionAnswerIndex) {
          return AnswerCardStatus.error;
        }

        if (index == currentQuestion.rightAnswerIndex - 1) {
          return AnswerCardStatus.right;
        }
        return AnswerCardStatus.disabled;
      });
    }
  }

  void changeRating(int rating, int level) {
    ratings[level] = rating;
    notifyListeners();
  }

  void chooseLevel(int level) {
    currentLevel = level;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds == 0) {
          timer.cancel();
        } else {
          seconds--;
        }
        notifyListeners();
      },
    );
  }

  void updateCurrentLevelRating() {
    if (rightAnswers <= 2) {
      ratings[currentLevel!] = 1;
    } else if (rightAnswers <= 3) {
      ratings[currentLevel!] = 2;
    } else if (rightAnswers == 4) {
      ratings[currentLevel!] = 3;
    }
  }

  void reset() {
    currentScore = null;
    seconds = 60;
    timer = null;
    currentLevel = null;
    currentQuestionIndex = 0;
    rightAnswers = 0;
    isFinish = false;
    currentQuestionAnswerIndex = null;
    notifyListeners();
  }

  void chooseAnswer(int index) {
    currentQuestionAnswerIndex = index;
    notifyListeners();
    if (currentQuestion.rightAnswerIndex == index + 1) {
      rightAnswers++;
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex == 3) {
      currentScore = rightAnswers * (60 - seconds);
 
      seconds = 60;
      timer!.cancel();
      timer = null;
      updateCurrentLevelRating();

      isFinish = true;
    } else {
      currentQuestionIndex++;
      currentQuestionAnswerIndex = null;
    }

    notifyListeners();
  }
}
