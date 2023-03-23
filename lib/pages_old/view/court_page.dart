import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:fluttartur/pages_old/view/mission_page.dart';

class CourtPage extends StatelessWidget {
  const CourtPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: CourtPage());

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CourtPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 49, 49, 49),
        title: const Text("Dwór"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Accolade.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColoredBox(
              color: const Color.fromARGB(172, 63, 63, 63),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    MissionTile(),
                    MissionTile(),
                    MissionTile(),
                    MissionTile(),
                    MissionTile(),
                  ],
                ),
              ),
            ),
            Expanded(child: TeamWrap()),
            ColoredBox(
              color: const Color.fromARGB(172, 63, 63, 63),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        iconSize: 60,
                        color: Colors.white,
                        icon: const Icon(Icons.close),
                        onPressed: () {},
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green,
                      child: IconButton(
                        iconSize: 60,
                        color: Colors.white,
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MissionPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamWrap extends StatelessWidget {
  const TeamWrap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text("Dworzanie:",
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                PlayerTile(nickname: "Michał"),
                PlayerTile(nickname: "Jędrek"),
                PlayerTile(nickname: "Szymon"),
                PlayerTile(nickname: "Janek"),
                PlayerTile(nickname: "Maciek"),
                PlayerTile(nickname: "Kinga"),
                PlayerTile(nickname: "Piotrek"),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const <Widget>[
                Text("Drużyna:",
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                PlayerTile(nickname: "Szymon"),
                PlayerTile(nickname: "Michał"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    required this.nickname,
  });

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(160, 213, 213, 213),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          nickname,
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}

class MissionTile extends StatelessWidget {
  const MissionTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Color.fromARGB(255, 35, 35, 35),
      child: IconButton(
        iconSize: 40,
        color: Color.fromARGB(255, 255, 226, 181),
        icon: const Icon(Icons.location_on),
        onPressed: () {},
      ),
    );
  }
}
