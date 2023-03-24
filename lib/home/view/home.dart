import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/home/home.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static Page<void> page() => const MaterialPage<void>(child: Home());

  @override
  Widget build(BuildContext context) {
    final dataRepository = context.read<DataRepository>();
    return BlocProvider(
      create: (_) => RoomCubit(dataRepository),
      child: Builder(builder: (context) {
        return FlowBuilder<RoomStatus>(
          state: context.select((RoomCubit cubit) => cubit.state.status),
          onGeneratePages: onGenerateRoomViewPages,
          //observers: [HeroController()], // TODO not necessary now
        );
      }),
    );
  }
}
