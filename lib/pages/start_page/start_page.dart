import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttartur/data/room.dart';
import 'package:fluttartur/data/rooms_data_source.dart';
import 'package:flutter/services.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => RoomsDataSource(
        firestore: FirebaseFirestore.instance,
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/startpagebg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  child: TextField(
                    maxLength: 6, // TODO move to config
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID pokoju',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 30),
                      backgroundColor: const Color.fromARGB(255, 16, 70, 114),
                      padding: const EdgeInsets.all(10)),
                  onPressed: () {},
                  child: const Text('Dołącz'),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 43, 97, 141),
                  ),
                  onPressed: () {},
                  child: const Text('Stwórz pokój'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
