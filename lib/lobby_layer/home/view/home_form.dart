import 'package:fluttartur/lobby_layer/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app_layer/app/app.dart';
import 'package:fluttartur/lobby_layer/matchup/matchup.dart';
import 'package:formz/formz.dart';

class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Align(
      alignment: const Alignment(0, -2 / 3),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            Text(user.email ?? ''),
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
            const SizedBox(height: 16),
            _JoinRoomButton(),
            const SizedBox(height: 16),
            _CreateRoomButton(),
          ],
        ),
      ),
    );
  }
}

class _RoomIdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (roomId) => context.read<HomeCubit>().roomIdChanged(roomId),
      //keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'ID pokoju',
        helperText: '',
      ),
    );
  }
}

class _JoinRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : FilledButton(
                onPressed: !state.status.isValidated
                    ? null
                    : () {
                        // TODO move this state to bloc
                        // TODO move this to routes
                        context.read<HomeCubit>().joinRoom().then((value) =>
                            Navigator.of(context)
                                .push<void>(MatchupHostPage.route()));
                      },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Dołącz', style: TextStyle(fontSize: 25)),
                ),
              );
      },
    );
  }
}

class _CreateRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO add state which gives CircularProgressIndicator here
    return FilledButton.tonal(
      onPressed: () {
        // TODO move this state to bloc
        // TODO move this to routes
        context.read<HomeCubit>().createRoom().then((value) =>
            Navigator.of(context).push<void>(MatchupHostPage.route()));
      },
      child: const Text('Stwórz pokój', style: TextStyle(fontSize: 20)),
    );
  }
}
