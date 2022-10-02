import 'package:flutter/material.dart';

class CustomStack extends StatelessWidget {
  const CustomStack({
    required this.image,
    required this.icon,
    required this.text1,
    required this.text2,
    required this.padding_top,
    required this.padding_left,
    required this.padding,
    required this.color,
  });
  final String image;
  final String icon;
  final String text1;
  final String text2;
  final double padding_top;
  final double padding_left;
  final double padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: padding_top),
          child: Container(
            alignment: Alignment.bottomCenter,
            width: 250,
            height: 380,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset(
                          icon,
                          width: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text1,
                              style: const TextStyle(
                                  color: Color(0xff2D2D2D),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              text2,
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(padding_left, padding, 0, 0),
          child: Image.asset(
            image,
            height: 380,
          ),
        ),
      ],
    );
  }
}
