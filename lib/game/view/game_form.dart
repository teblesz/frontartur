import 'package:data_repository/data_repository.dart';
import 'package:data_repository/models/member.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fluttartur/pages_old/view/mission_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quest_tiles.dart';
part 'team_wrap.dart';
part 'bottom_buttons.dart';

class GameForm extends StatelessWidget {
  const GameForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _QuestTiles(),
        Expanded(
          child: _TeamWrap(),
        ),
        _TeamChoiceButtons(),
        BlocBuilder<GameCubit, GameState>(
            // TODO remove this
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return Text(state.status.name);
            })
      ],
    );
  }
}
