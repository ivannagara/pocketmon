import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex_app/pokemon/pokemon.dart';

abstract class PokemonRepository {
  Future<List<PokemonPreview>> getPokemonsFromGithub();
  Future<List<Pokemon>> getPokemonsFromPokeApi({
    int queryStartIndex = 0,
    int querySize = 15,
  });
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
  Future<List<PokemonPreview>> getPokemonsFromGithub() async {
    final res = await _client.get(Uri.parse(hostUrl + path));

    if (res.statusCode != 200) {
      throw Exception('${res.statusCode}: ${res.body}');
    }

    if (res.body.isEmpty) {
      throw Exception('JSON body is empty');
    }

    final decodedJson = json.decode(res.body) as Map<String, dynamic>?;
    final results = decodedJson?['pokemon'] as List<dynamic>?;

    if (results == null) throw Exception('Pokemons body not found');

    final pokemonPreviewList =
        results.map((e) => PokemonPreview.fromJson(e ?? {})).toList();

    return pokemonPreviewList;
  }

  @override
  Future<List<Pokemon>> getPokemonsFromPokeApi({
    int queryStartIndex = 0,
    int querySize = 15,
  }) async {
    const pokeApiHostUrl = 'https://pokeapi.co/api/v2/';
    final res = await _client.get(
      Uri.parse(
        '${pokeApiHostUrl}pokemon?limit=$querySize&offset=$queryStartIndex',
      ),
    );

    if (res.statusCode != 200) {
      throw Exception('${res.statusCode}: ${res.body}');
    }

    if (res.body.isEmpty) {
      throw Exception('JSON body is empty');
    }

    final decodedBody = json.decode(res.body) as Map<String, dynamic>?;

    if (decodedBody == null) {
      throw Exception('Failed to decode json body');
    }

    final pokemonsJsonList = decodedBody['results'] as List<dynamic>?;

    if (pokemonsJsonList == null) {
      throw Exception('Cannot get pokemons JSON list');
    }

    final listOfPokemons =
        pokemonsJsonList.map((e) => Pokemon.fromJson(e)).toList();

    return listOfPokemons;
  }
}
