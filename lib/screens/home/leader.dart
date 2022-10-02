import 'package:flutter/material.dart';
import 'package:nasa/core/app_route.dart';

class Leader extends StatelessWidget {
  const Leader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoute.leaderboard);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Stack(
                children: const [
                  Positioned(
                    left: 40,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://john-mohamed.com/wp-content/uploads/2018/05/Profile_avatar_placeholder_large.png'),
                      radius: 25,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://as1.ftcdn.net/v2/jpg/02/88/79/62/1000_F_288796275_NAlmJ0IESWj9EpsuVcSRnOAA79wPCQPQ.jpg'),
                      radius: 25,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.fineartamerica.com/images-medium-5/lost-astronaut-roberta-ferreira.jpg'),
                    radius: 25,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'see player rank',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff767070)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
