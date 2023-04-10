import 'package:equatable/equatable.dart';

class PokemonPreview extends Equatable {
  const PokemonPreview({
    this.name = '',
    this.url = '',
  });

  factory PokemonPreview.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String?;
    final url = json['url'] as String?;

    return PokemonPreview(
      name: name ?? '',
      url: url ?? '',
    );
  }

  final String name;
  final String url;

  @override
  List<Object?> get props => [
        name,
        url,
      ];
}
