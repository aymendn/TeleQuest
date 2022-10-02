import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    Key? key,
    required this.score,
    required this.stars,
  }) : super(key: key);

  final int score;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Star(top: 25, isFull: stars > 0),
            Star(isFull: stars > 1),
            Star(top: 25, isFull: stars > 2),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/score-shape.png',
                width: 170,
              ),
              Text(
                score.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Star extends StatelessWidget {
  const Star({
    Key? key,
    this.top = 0,
    required this.isFull,
  }) : super(key: key);

  final double top;
  final bool isFull;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: top),
      child: Icon(
        isFull ? Icons.star_rounded : Icons.star_outline_rounded,
        size: 55,
        color: Colors.amber,
      ),
    );
  }
}
