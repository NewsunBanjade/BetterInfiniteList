import 'package:better_infinite_list/better_infinite_list.dart';
import 'package:better_infinite_list_example/cubit/ricky_morty_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (context) => RickyMortyCubit(),
          child: const TestWidget(),
        ),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = RickyMortyCubit();
    return BlocBuilder<RickyMortyCubit, RickyMortyState>(
      bloc: cubit,
      builder: (context, state) {
        return BetterInfiniteList(
          itemCount: state.characterResponse?.characters.length ?? 0,
          itemBuilder: (context, index) {
            final currentItem = state.characterResponse!.characters[index];
            return ListTile(
              title: Text(currentItem.name),
              leading: Image.network(
                currentItem.image,
                width: 50,
                height: 60,
              ),
            );
          },
          fetchMore: () {
            cubit.increaseAndLoad();
          },
          sepratorSpacing: 10,
          hasData: state.characterResponse?.characters.isNotEmpty ?? false,
          status: switch (state.status) {
            Status.failed => BetterInfiniteStatus.error,
            Status.initial => BetterInfiniteStatus.idle,
            Status.loading => BetterInfiniteStatus.loading,
            Status.loaded => BetterInfiniteStatus.idle,
          },
          errorWidget: (context) => ListTile(
            title: const Text("Error Loading"),
            trailing: ElevatedButton(
                onPressed: () {
                  cubit.loadData(state.currentPage);
                },
                child: const Text("Retry")),
          ),
        );
      },
    );
  }
}
