import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa/core/app_route.dart';
import 'package:nasa/providers/auth.dart';

import 'custom_divider.dart';
import 'custom_setting.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1F1147), Color(0xff362679)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 80),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                        color: Color(0xff37EBBB),
                        fontSize: 20,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: ClipOval(
                        child: Image.network(auth.user.profilePicture)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user.name ?? '',
                          style: const TextStyle(
                              color: Color(0xfff3f3f3), fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          auth.user.email ?? '',
                          style: const TextStyle(
                              color: Color(0xff9B9898), fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  const CustomSetting(
                    title: 'General',
                    icon: Icons.settings,
                    properti: 'Language and input setting',
                    padding: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomDivider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomSetting(
                      title: 'Privacy',
                      icon: Icons.privacy_tip_outlined,
                      properti: 'Account password setting',
                      padding: 62),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomDivider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomSetting(
                      title: 'Notification',
                      icon: Icons.notifications,
                      properti: 'Block,Allow Priorities ',
                      padding: 90),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomDivider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomSetting(
                      title: 'About',
                      icon: Icons.info_outline,
                      properti: 'Know about app',
                      padding: 140),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomDivider(),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomSetting(
                      onTap: () async {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, AppRoute.welcome);
                        await auth.logout();
                      },
                      title: 'logout',
                      icon: Icons.logout_outlined,
                      properti: 'Logout from app',
                      padding: 135),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
