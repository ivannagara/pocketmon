import 'package:pokedex_app/pokemon/pokemon.dart';

abstract class HomeRepository {
  Future<Pokemon> getPokemon();
}

class HomeHTTPRepository implements HomeRepository {
  @override
  Future<Pokemon> getPokemon() async {
    return const Pokemon();
  }
}
