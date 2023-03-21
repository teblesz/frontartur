import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

//TODO misje maja zmieniajace sie tła
// QUEST xd

class MissionPage extends StatelessWidget {
  const MissionPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MissionPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 49, 49, 49),
        title: const Text("Misja"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/knights_mission.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              ColoredBox(
                color: const Color.fromARGB(172, 63, 63, 63),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    // TODO randomize positions of buttons
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          iconSize: 100,
                          color: Colors.white,
                          icon: const Icon(Icons.close),
                          onPressed: () {},
                        ),
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          iconSize: 100,
                          color: Colors.white,
                          icon: const Icon(Icons.check),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
