import 'package:pokedex_app/pokemon/pokemon_repository.dart';

import 'home/repository/home_repository.dart';

abstract class Repository {
  HomeRepository get getHomeRepository;
  PokemonRepository get getPokemonRepository;
}

class HTTPRepository implements Repository {
  final hostUrl = 'https://raw.githubusercontent.com';

  @override
  HomeRepository get getHomeRepository => HomeHTTPRepository();

  @override
  PokemonRepository get getPokemonRepository => PokemonHTTPRepository(
      hostUrl: hostUrl, path: '/Biuni/PokemonGO-Pokedex/master/pokedex.json');
}
