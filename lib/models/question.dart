// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Question {
  final int level;
  final String question;
  final String answers;
  final int rightAnswerIndex;
  final String? image;

  Question({
    required this.level,
    required this.question,
    required this.answers,
    required this.rightAnswerIndex,
    this.image,
  });

  List<String> get answersList => answers.split(',') ;

  Question copyWith({
    int? level,
    String? question,
    String? answers,
    int? rightAnswerIndex,
    String? image,
  }) {
    return Question(
      level: level ?? this.level,
      question: question ?? this.question,
      answers: answers ?? this.answers,
      rightAnswerIndex: rightAnswerIndex ?? this.rightAnswerIndex,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'level': level,
      'question': question,
      'answers': answers,
      'rightAnswerIndex': rightAnswerIndex,
      'image': image,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      level: map['level'] as int,
      question: map['question'] as String,
      answers: map['answers'] as String,
      rightAnswerIndex: map['rightAnswerIndex'],
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Question(level: $level, question: $question, answers: $answers, rightAnswerIndex: $rightAnswerIndex, image: $image)';
  }

  @override
  bool operator ==(covariant Question other) {
    if (identical(this, other)) return true;

    return other.level == level &&
        other.question == question &&
        other.answers == answers &&
        other.rightAnswerIndex == rightAnswerIndex &&
        other.image == image;
  }

  @override
  int get hashCode {
    return level.hashCode ^
        question.hashCode ^
        answers.hashCode ^
        rightAnswerIndex.hashCode ^
        image.hashCode;
  }
}
