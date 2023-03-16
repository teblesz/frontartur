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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "images/startpagebg.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Home'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                ),
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                },
                child: const Text("Log out"),
              )
            ],
          ),
          body: Center(
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
                FilledButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 30)),
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Dołącz'),
                  ),
                ),
                const SizedBox(height: 15),
                FilledButton.tonal(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {},
                  child: const Text('Stwórz pokój'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
