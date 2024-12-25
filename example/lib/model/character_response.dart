import 'dart:convert';

import 'package:flutter/foundation.dart';

class CharacterResponse {
  final int page;
  final int count;
  final List<Character> characters;
  CharacterResponse({
    required this.page,
    required this.count,
    required this.characters,
  });

  CharacterResponse copyWith({
    int? page,
    int? count,
    List<Character>? characters,
  }) {
    return CharacterResponse(
      page: page ?? this.page,
      count: count ?? this.count,
      characters: characters ?? this.characters,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'count': count,
      'characters': characters.map((x) => x.toMap()).toList(),
    };
  }

  factory CharacterResponse.fromMap(Map<String, dynamic> map) {
    final info = map['info'];
    return CharacterResponse(
      page: info['pages']?.toInt() ?? 0,
      count: info['count']?.toInt() ?? 0,
      characters: List<Character>.from(
          map['results']?.map((x) => Character.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterResponse.fromJson(String source) =>
      CharacterResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'CharacterResponse(page: $page, count: $count, characters: $characters)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CharacterResponse &&
        other.page == page &&
        other.count == count &&
        listEquals(other.characters, characters);
  }

  @override
  int get hashCode => page.hashCode ^ count.hashCode ^ characters.hashCode;
}

class Character {
  final int id;
  final String name;
  final String image;
  Character({
    required this.id,
    required this.name,
    required this.image,
  });

  Character copyWith({
    int? id,
    String? name,
    String? image,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source));

  @override
  String toString() => 'Character(id: $id, name: $name, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.id == id &&
        other.name == name &&
        other.image == image;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ image.hashCode;
}
