import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => CharactersPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "images/merlin.png",
            alignment: AlignmentDirectional.center,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).defineSpecialCharacters),
          ),
          body: const _CharactersView(),
        ),
      ],
    );
  }
}

// TODO change to cubit later
class _CharactersView extends StatefulWidget {
  const _CharactersView({
    super.key,
  });

  @override
  State<_CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<_CharactersView> {
  bool hasMerlinAndAssassin = false;
  bool hasPercivalAndMorgana = false;

  void addMerlinAndAssassin() => setState(() => hasMerlinAndAssassin = true);

  void addPercivalAndMorgana() => setState(() => hasPercivalAndMorgana = true);

  void removeMerlinAndAssassin() => setState(() {
        hasMerlinAndAssassin = false;
        hasPercivalAndMorgana = false;
      });

  void removePercivalAndMorgana() => setState(() {
        hasPercivalAndMorgana = false;
      });

  Future<void> updateSpecialCharacters() async {
    final List<String> characters = [];
    if (hasMerlinAndAssassin) {
      characters.add('good_merlin');
      characters.add('evil_assassin');
    }
    if (hasPercivalAndMorgana) {
      characters.add('good_percival');
      characters.add('evil_morgana');
    }
    await context.read<DataRepository>().setSpecialCharacters(characters);
  }

  @override
  void initState() {
    super.initState();
    final list = context.read<DataRepository>().currentRoom.specialCharacters;
    if (list.contains("good_merlin")) hasMerlinAndAssassin = true;
    if (list.contains("good_percival")) hasPercivalAndMorgana = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CharactersList(
              listGood: true,
              hasMerlinAndAssassin: hasMerlinAndAssassin,
              hasPercivalAndMorgana: hasPercivalAndMorgana,
            ),
            const SizedBox(width: 10),
            _CharactersList(
              listGood: false,
              hasMerlinAndAssassin: hasMerlinAndAssassin,
              hasPercivalAndMorgana: hasPercivalAndMorgana,
            ),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () => !hasMerlinAndAssassin
                    ? addMerlinAndAssassin()
                    : removeMerlinAndAssassin(),
                child: Text(
                  AppLocalizations.of(context).addMerlinAndAssassin,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: !hasMerlinAndAssassin
                    ? null
                    : () => !hasPercivalAndMorgana
                        ? addPercivalAndMorgana()
                        : removePercivalAndMorgana(),
                child: Text(
                  AppLocalizations.of(context).addPercivalAndMorgana,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            updateSpecialCharacters();
            context.read<DataRepository>().refreshRoomCache();
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context).confirm,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
    ;
  }
}

class _CharactersList extends StatelessWidget {
  const _CharactersList({
    super.key,
    this.listGood = true,
    required this.hasMerlinAndAssassin,
    required this.hasPercivalAndMorgana,
  });

  final bool listGood;
  final bool hasMerlinAndAssassin;
  final bool hasPercivalAndMorgana;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          listGood
              ? AppLocalizations.of(context).goodColon
              : AppLocalizations.of(context).evilColon,
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 10),
        !hasMerlinAndAssassin
            ? const SizedBox.shrink()
            : (listGood
                ? _TextCard(text: AppLocalizations.of(context).merlin)
                : _TextCard(text: AppLocalizations.of(context).assassin)),
        !hasPercivalAndMorgana
            ? const SizedBox.shrink()
            : (listGood
                ? _TextCard(text: AppLocalizations.of(context).percival)
                : _TextCard(text: AppLocalizations.of(context).morgana)),
      ],
    );
  }
}

class _TextCard extends StatelessWidget {
  const _TextCard({
    super.key,
    this.text = "",
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
