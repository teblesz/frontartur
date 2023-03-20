import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:fluttartur/pages_old/view/court_page.dart';

// TODO zmiana kolejnosci graczy -> ma byc tak jak przy stole

class LobbyHostPage extends StatelessWidget {
  const LobbyHostPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LobbyHostPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 49, 49),
        title: const Text('Pokój'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/startpagebg.jpg"),
            alignment: AlignmentDirectional.centerEnd,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const <Widget>[
                  Card(
                    color: Color.fromARGB(193, 255, 255, 255),
                    child: ListTile(
                      title: Text('player1'),
                      trailing: Icon(Icons.more_vert),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(193, 255, 255, 255),
                    child: ListTile(
                      title: Text('player2'),
                      trailing: Icon(Icons.more_vert),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(193, 255, 255, 255),
                    child: ListTile(
                      title: Text('player3'),
                      trailing: Icon(Icons.more_vert),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    padding: const EdgeInsets.all(5),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 43, 97, 141),
                  ),
                  onPressed: () {},
                  child: const Text('Zdefiniuj role'),
                ),
                const SizedBox(width: 15),
                OutlinedButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    padding: const EdgeInsets.all(5),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 16, 70, 114),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CourtPage()),
                    );
                  },
                  child: const Text('Rozpocznij grę'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
