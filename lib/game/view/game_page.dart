import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:fluttartur/game/view/game_form.dart';
import 'package:fluttartur/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: GamePage());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "images/Accolade.jpg",
            alignment: AlignmentDirectional.center,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Game'),
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text(AppLocalizations.of(context).forgotCharacter),
                    onTap: () => pushCharacterInfoDialog(context),
                  ),
                  PopupMenuItem(
                    child: Text(AppLocalizations.of(context).leaveRoom),
                    onTap: () => context.read<RoomCubit>().leaveRoom(),
                  ),
                ],
              ),
            ],
          ),
          body: BlocProvider(
            create: (_) => GameCubit(context.read<DataRepository>()),
            child: const GameForm(),
          ),
        ),
      ],
    );
  }
}
