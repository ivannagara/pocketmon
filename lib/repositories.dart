import 'package:pokedex_app/pokemon/pokemon_repository.dart';

import 'home/repository/home_repository.dart';

abstract class Repository {
  HomeRepository get getHomeRepository;
  PokemonRepository get getPokemonRepository;
}

class HTTPRepository implements Repository {
  final hostUrl = 'https://pokeapi.co/api/v2/';

  @override
  HomeRepository get getHomeRepository => HomeHTTPRepository();

  @override
  PokemonRepository get getPokemonRepository => PokemonHTTPRepository(
      hostUrl: hostUrl, path: 'pokemon?limit=20&offset=0');
}
