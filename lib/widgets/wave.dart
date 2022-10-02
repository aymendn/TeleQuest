import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperTwo(flip: true, reverse: true),
      child: Container(
        height: 50,
        width: double.infinity,
        color: const Color(0xff1F1147),
      ),
    );
  }
}
