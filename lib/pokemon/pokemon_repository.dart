import 'package:pokedex_app/pokemon/models/pokemon_preview.dart';

import 'package:http/http.dart' as http;

abstract class PokemonRepository {
  Future<List<PokemonPreview>> getPokemons();
}

class PokemonHTTPRepository implements PokemonRepository {
  PokemonHTTPRepository({
    http.Client? client,
    required this.url,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String url;

  @override
  Future<List<PokemonPreview>> getPokemons() async {
    final res = await _client.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('${res.statusCode}: ${res.body}');
    }
    return [];
  }
}
