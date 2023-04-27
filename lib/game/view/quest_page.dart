import 'dart:math';
import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key, required this.disableEmbark});

  final void Function() disableEmbark;

  static Route<void> route(void Function() disableEmbark) {
    return MaterialPageRoute<void>(
      builder: (_) => QuestPage(disableEmbark: disableEmbark),
    );
  }

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  @override
  void initState() {
    super.initState();
    _disableEmbark = widget.disableEmbark;
  }

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
  const _VoteQuestPanel({super.key, required this.disableEmbark});

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
                disableEmbark: disableEmbark,
              ),
              _VoteQuestButton(
                isPositive: !randomBool,
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
    required this.disableEmbark,
  });

  final bool isPositive;
  final void Function() disableEmbark;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final playerCharacter =
              context.read<DataRepository>().currentPlayer.character;
          // good player cant click on "fail" button
          if (playerCharacter == 'good' && isPositive == false) return;
          //TODO use gamecubit here (?) (reverted in commit 7ab80bc7ad378f6f6a2186bb55a544c889e04ec1)
          context.read<DataRepository>().voteQuest(isPositive);
          disableEmbark();
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(isPositive
                ? Colors.green.shade900
                : const Color.fromARGB(255, 129, 20, 20))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            isPositive ? "Success" : "Fail",
            style: const TextStyle(fontSize: 25),
          ),
        ));
  }
}
