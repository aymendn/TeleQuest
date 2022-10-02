import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa/core/app_route.dart';
import 'package:nasa/providers/auth.dart';
import 'package:nasa/providers/questions.dart';
import 'package:nasa/widgets/level_card.dart';

class LevelsScreen extends ConsumerWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const SizedBox(width: 10),
                const Text(
                  'levels',
                  style: TextStyle(fontSize: 23),
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 24,
            itemBuilder: (BuildContext context, int index) {
              return LevelCard(
                level: index + 1,
                stars: questions.ratings[index],
                isOpen: index <= auth.user.offlineLevel,
                // isOpen: true,
                onPressed: () {
                  questions.chooseLevel(index);
                  Navigator.of(context).pushNamed(AppRoute.offlineGame);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
