import 'package:better_infinite_list_example/model/character_response.dart';
import 'package:better_infinite_list_example/rickyandmorty_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ricky_morty_state.dart';

class RickyMortyCubit extends Cubit<RickyMortyState> {
  RickyMortyCubit() : super(const RickyMortyState()) {
    rickyandmortyService = RickyandmortyService();
    loadData(1);
  }

  bool testFailure = false;

  late final RickyandmortyService rickyandmortyService;

  void loadData(int page) async {
    if (state.status == Status.loading) return;
    emit(state.copyWith(status: Status.loading));
    final CharacterResponse? character = getCharacterResponse();
    await Future.delayed(const Duration(seconds: 2));
    try {
      if (!testFailure && page == 2) {
        testFailure = true;
        throw "Error Find";
      }
      final data = await rickyandmortyService.getCharacters(page: page);
      emit(state.copyWith(
          currentPage: page,
          status: Status.loaded,
          characterResponse: data.copyWith(
              characters: [...?character?.characters, ...data.characters])));
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), currentPage: page, status: Status.failed));
    }
  }

  void increaseAndLoad() {
    if (state.status == Status.failed) return;
    loadData(state.currentPage + 1);
  }

  CharacterResponse? getCharacterResponse() {
    return state.characterResponse;
  }
}
