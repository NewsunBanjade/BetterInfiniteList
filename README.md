## Features

Will Update Later 😅

## Getting started

Example Uses Bloc for managing State.

## Usage

```dart


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


```
