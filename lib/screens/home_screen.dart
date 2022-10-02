import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa/providers/auth.dart';

import '../core/app_route.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('home')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          // padding: const EdgeInsets.all(20),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                auth.user.imageUrl ??
                    'https://upload.wikimedia.org/wikipedia/commons/a/aa/Sin_cara.png',
              ),
            ),
            const SizedBox(height: 10),
            Text('Name: ${auth.user.name}'),
            Text('Email: ${auth.user.email}'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await auth.logout();
                } catch (e) {
                  print(e);
                  return;
                }
                Navigator.of(context).pushReplacementNamed(AppRoute.welcome);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoute.leaderboard);
              },
              child: const Text('Leaderboard'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoute.multiplayerSearch);
              },
              child: const Text('Multiplayer'),
            ),
            ElevatedButton(
              onPressed: () async {
                // final url = Uri.parse(
                //     'https://nasa-petacode-default-rtdb.firebaseio.com/rooms/room1.json');

                // await http.patch(url, body: {'user1': '3'});

                final database = FirebaseDatabase.instance.ref();

                final leaderBoardRef = database.child('rooms/room1');
                await leaderBoardRef.update({'user1': 'rrrr'});
              },
              child: const Text('do'),
            ),
          ],
        ),
      ),
    );
  }
}
