import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa/data/questions_data.dart';
import 'package:nasa/models/question.dart';

import 'questions.dart';

final offlineProvider = ChangeNotifierProvider<Offline>((ref) {
  return Offline();
});

class Offline extends ChangeNotifier {
  int currentQuestionIndex = 0;
  int? currentQuestionAnswerIndex;
  bool? isUserAnswering;
  bool isFinish = false;

  int userScore = 0;
  int enemyScore = 0;

  List<Question> get questions {
    return questionsData
        .sublist(0, 10)
        .map((q) => Question.fromMap(q))
        .toList();
  }

  Question get currentQuestion => questions[currentQuestionIndex];

  List<String> get currentAnswers => currentQuestion.answersList;

  bool get isWinner => userScore > enemyScore;

  bool get isChoseAnswer => answersStatus.contains(AnswerCardStatus.right);

  List<AnswerCardStatus> get answersStatus {
    if (currentQuestionAnswerIndex == null && isUserAnswering != null) {
      return List.generate(currentQuestion.answersList.length,
          (index) => AnswerCardStatus.normal);
    } else if (currentQuestionAnswerIndex == null && isUserAnswering == null) {
      return List.generate(currentQuestion.answersList.length,
          (index) => AnswerCardStatus.disabled);
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

  void chooseAnswerer(bool isUser) {
    isUserAnswering = isUser;
    notifyListeners();
  }

  bool isRightAnswer(int index) {
    return currentQuestion.rightAnswerIndex - 1 == index;
  }

  void answerQuestion(int index) {
    currentQuestionAnswerIndex = index;

    notifyListeners();

    if ((isUserAnswering! && isRightAnswer(index)) ||
        (!isUserAnswering! && !isRightAnswer(index))) {
      userScore++;
    } else {
      enemyScore++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (currentQuestionIndex < 9) {
      isUserAnswering = null;
      currentQuestionIndex++;
      currentQuestionAnswerIndex = null;
    } else {
      isFinish = true;
    }
    notifyListeners();
  }

  void reset() {
    currentQuestionAnswerIndex = null;
    isUserAnswering = null;

    isFinish = false;

    currentQuestionIndex = 0;

    userScore = 0;
    enemyScore = 0;
    notifyListeners();
  }
}
