import 'dart:math';
import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestPage extends StatefulWidget {
  const QuestPage(
      {super.key, required this.gameContext, required this.disableEmbark});

  final BuildContext gameContext;
  final void Function() disableEmbark;

  static Route<void> route(void Function() disableEmbark) {
    return MaterialPageRoute<void>(
      builder: (context) =>
          QuestPage(gameContext: context, disableEmbark: disableEmbark),
    );
  }

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  @override
  void initState() {
    super.initState();
    _gameContext = widget.gameContext;
    _disableEmbark = widget.disableEmbark;
  }

  late BuildContext _gameContext;
  late void Function() _disableEmbark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "images/depature_dalle.png",
            alignment: AlignmentDirectional.center,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Quest Vote'),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Vote in secret!',
                style: TextStyle(fontSize: 40),
              ),
              Expanded(child: Container()),
              _VoteQuestPanel(
                gameContext: _gameContext,
                disableEmbark: _disableEmbark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VoteQuestPanel extends StatelessWidget {
  const _VoteQuestPanel(
      {super.key, required this.gameContext, required this.disableEmbark});

  final BuildContext gameContext;
  final void Function() disableEmbark;

  @override
  Widget build(BuildContext context) {
    final randomBool = Random().nextBool();
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _VoteQuestButton(
                isPositive: randomBool,
                gameContext: gameContext,
                disableEmbark: disableEmbark,
              ),
              _VoteQuestButton(
                isPositive: !randomBool,
                gameContext: gameContext,
                disableEmbark: disableEmbark,
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _VoteQuestButton extends StatelessWidget {
  const _VoteQuestButton({
    required this.isPositive,
    required this.gameContext,
    required this.disableEmbark,
  });

  final bool isPositive;

  final BuildContext gameContext;
  final void Function() disableEmbark;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          // TODO if player is good and this is fail button return null
          gameContext.read<GameCubit>().voteQuest(isPositive);
          disableEmbark();
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(isPositive
              ? const Color.fromARGB(120, 56, 142, 60)
              : const Color.fromARGB(120, 211, 47, 47)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            isPositive ? "Success" : "Fail",
            style: const TextStyle(fontSize: 25),
          ),
        ));
  }
}
