import 'package:authentication_repository/src/models/user.dart';
import 'package:fluttartur/home/home.dart';
import 'package:fluttartur/lobby/cubit/lobby_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app/app.dart';
import 'package:formz/formz.dart';
import 'package:fluttartur/widgets/widgets.dart';

class LobbyForm extends StatelessWidget {
  const LobbyForm({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Column(
      children: [
        const LanguageChangeButton(),
        Expanded(
          child: Align(
            alignment: const Alignment(0, -2 / 3),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //Text(AppLocalizations.of(context).helloWorld),
                  _UsersEmail(user: user),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 250,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: _RoomIdInput(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _JoinRoomButton(),
                  const SizedBox(height: 10),
                  _CreateRoomButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UsersEmail extends StatelessWidget {
  const _UsersEmail({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return !kDebugMode ? const SizedBox.shrink() : Text(user.email ?? '');
    });
  }
}

class _RoomIdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (roomId) => context.read<LobbyCubit>().roomIdChanged(roomId),
      //keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'room ID',
        helperText: '',
        //errorText: state.roomId.invalid ? 'invalid room ID' : null, //TODO alike in login
        // TODO !! add onError to joinRoom below with dialog about room gamestarted
      ),
    );
  }
}

// TODO !!! handle errors  // TODO deactivate when create room is processing
class _JoinRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LobbyCubit, LobbyState>(
      buildWhen: (previous, current) =>
          previous.statusOfJoin != current.statusOfJoin,
      builder: (context, state) {
        return state.statusOfJoin.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : FilledButton(
                onPressed: !state.statusOfJoin.isValidated ||
                        state.statusOfCreate.isSubmissionInProgress
                    ? null
                    : () async {
                        // context.read<LobbyCubit>().roomIdChanged(
                        //     "mlMOv1XpSl1b4ETIVR94"); //TODO !!! remove this
                        // TODO  rework this thing
                        await context.read<LobbyCubit>().joinRoom();
                        if (state.statusOfJoin.isValidated) {
                          // TODO !!! change to have event sent to inside lobbycubit
                          context.read<RoomCubit>().goToMatchup();
                        } else {
                          print("invalid room ID");
                          //TODO push popup, or write info somwhere
                        }
                      },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Join', style: TextStyle(fontSize: 25)),
                ),
              );
      },
    );
  }
}

class _CreateRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LobbyCubit, LobbyState>(
      buildWhen: (previous, current) =>
          previous.statusOfCreate != current.statusOfCreate,
      builder: (context, state) {
        final user = context.select((AppBloc bloc) => bloc.state.user);
        return state.statusOfCreate.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : FilledButton.tonal(
                onPressed: () {
                  // TODO rework this
                  context.read<LobbyCubit>().createRoom(userId: user.id).then(
                        (_) => context.read<RoomCubit>().goToMatchup(),
                      );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Create room', style: TextStyle(fontSize: 20)),
                ),
              );
      },
    );
  }
}
