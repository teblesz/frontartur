import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttartur/data/room.dart';
import 'package:fluttartur/data/rooms_data_source.dart';
import 'package:flutter/services.dart';

class LobbyHostPage extends StatefulWidget {
  const LobbyHostPage({super.key});

  @override
  State<LobbyHostPage> createState() => _LobbyHostPageState();
}

class _LobbyHostPageState extends State<LobbyHostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/courtiers.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 43, 97, 141),
                ),
                onPressed: () {},
                child: const Text('welcome in pokój'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
