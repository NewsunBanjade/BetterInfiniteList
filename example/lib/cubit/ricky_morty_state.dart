part of './ricky_morty_cubit.dart';

enum Status { initial, loading, loaded, failed }

class RickyMortyState extends Equatable {
  const RickyMortyState(
      {this.characterResponse,
      this.status = Status.initial,
      this.currentPage = 1,
      this.message});

  final CharacterResponse? characterResponse;
  final Status status;
  final int currentPage;
  final String? message;

  @override
  List<Object?> get props => [characterResponse, message, status, message];

  RickyMortyState copyWith({
    CharacterResponse? characterResponse,
    Status? status,
    int? currentPage,
    String? message,
  }) {
    return RickyMortyState(
      characterResponse: characterResponse ?? this.characterResponse,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      message: message ?? this.message,
    );
  }
}
