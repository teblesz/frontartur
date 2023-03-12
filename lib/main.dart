import 'package:fluttartur/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttartur/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:fluttartur/data/rooms_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const app = StartPage();
  runApp(const _App(app: app));
}

class _App extends StatefulWidget {
  const _App({
    Key? key,
    required this.app,
  }) : super(key: key);

  final Widget app;

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => RoomsDataSource(
              firestore: FirebaseFirestore.instance,
            ),
        child: MaterialApp(
          home: FutureBuilder(
              future: _initialization,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return widget.app;
                  default:
                    return const ColoredBox(
                      color: Colors.green,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),
                    );
                }
              }),
        ));
  }
}
