import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/home/home.dart';
import 'package:fluttartur/pages_old/pages_old.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          )
        ],
      ),
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
              const SizedBox(height: 4),
              Text(user.email ?? '', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(user.name ?? '', style: textTheme.headlineSmall),
              SizedBox(
                width: 250,
                child: TextField(
                  maxLength: 6, // TODO move to config
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'ID pokoju',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) {
                    ;
                  },
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
    );
  }
}
