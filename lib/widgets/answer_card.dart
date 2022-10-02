import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/questions.dart';

Color textColor(AnswerCardStatus answerCardStatus) {
  switch (answerCardStatus) {
    case AnswerCardStatus.error:
      return Colors.redAccent;
    case AnswerCardStatus.right:
      return Colors.green;
    case AnswerCardStatus.disabled:
      return Colors.black26;
    default:
      return Colors.black54;
  }
}

Color borderColor(AnswerCardStatus answerCardStatus) {
  switch (answerCardStatus) {
    case AnswerCardStatus.error:
      return Colors.redAccent;
    case AnswerCardStatus.right:
      return Colors.green;
    case AnswerCardStatus.disabled:
      return Colors.grey.shade100;

    default:
      return Colors.grey.shade300;
  }
}

Color bgColor(AnswerCardStatus answerCardStatus) {
  switch (answerCardStatus) {
    case AnswerCardStatus.error:
      return const Color.fromARGB(71, 255, 79, 62);
    case AnswerCardStatus.right:
      return const Color.fromARGB(55, 69, 255, 76);

    default:
      return Colors.white;
  }
}

IconData adaptiveIcon(AnswerCardStatus answerCardStatus) {
  switch (answerCardStatus) {
    case AnswerCardStatus.error:
      return Icons.error;
    case AnswerCardStatus.right:
      return Icons.check_circle;

    default:
      return Icons.circle_outlined;
  }
}

class AnswerCard extends ConsumerWidget {
  const AnswerCard({
    super.key,
    required this.answer,
    required this.answerCardStatus,
    required this.onTap,
  });

  final String answer;
  final AnswerCardStatus answerCardStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, ref) {
    final questions = ref.watch(questionsProvider);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor(answerCardStatus),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor(answerCardStatus), width: 3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                answer,
                style: TextStyle(color: textColor(answerCardStatus)),
              ),
            ),
            Icon(
              adaptiveIcon(answerCardStatus),
              color: textColor(answerCardStatus),
            ),
          ],
        ),
      ),
    );
  }
}
