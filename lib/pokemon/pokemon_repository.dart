import 'models/pokemon.dart';
import 'package:http/http.dart' as http;

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemons();
}

class PokemonHTTPRepository implements PokemonRepository {
  PokemonHTTPRepository({
    http.Client? client,
    required this.url,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String url;

  @override
  Future<List<Pokemon>> getPokemons() async {
    final res = await _client.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('${res.statusCode}: ${res.body}');
    }
    return [];
  }
}
