import 'package:pokedex_app/pokemon/models/pokemon_preview.dart';

import 'package:http/http.dart' as http;

abstract class PokemonRepository {
  Future<List<PokemonPreview>> getPokemons();
}

class PokemonHTTPRepository implements PokemonRepository {
  PokemonHTTPRepository({
    http.Client? client,
    required this.hostUrl,
    required this.path,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String hostUrl;
  final String path;

  @override
  Future<List<PokemonPreview>> getPokemons() async {
    final res = await _client.get(Uri.parse(hostUrl + path));
    if (res.statusCode != 200) {
      throw Exception('${res.statusCode}: ${res.body}');
    }
    return [];
  }
}
