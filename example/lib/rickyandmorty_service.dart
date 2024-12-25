import 'package:better_infinite_list_example/model/character_response.dart';
import 'package:dio/dio.dart';

class RickyandmortyService {
  late final Dio dio;
  RickyandmortyService() {
    dio = Dio()
      ..options = BaseOptions(baseUrl: 'https://rickandmortyapi.com/api/');
  }

  Future<CharacterResponse> getCharacters({int page = 1}) async {
    try {
      final data = (await dio.get("character", queryParameters: {
        "page": page,
      }))
          .data;

      return CharacterResponse.fromMap(data);
    } catch (e) {
      rethrow;
    }
  }
}
