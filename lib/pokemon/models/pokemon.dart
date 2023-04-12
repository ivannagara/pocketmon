import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  const Pokemon({
    this.name = '',
    this.pokemonDataUrl = '',
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String?;
    final url = json['url'] as String?;

    return Pokemon(
      name: name ?? '',
      pokemonDataUrl: url ?? '',
    );
  }

  final String name;
  final String pokemonDataUrl;

  @override
  List<Object?> get props => [
        name,
        pokemonDataUrl,
      ];
}
