import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';

void main() {
  group('Pokemon', () {
    test('should be initializablle', () {
      const res = Pokemon();
      expect(res, isA<Pokemon>());
    });
    group('fromJson', () {
      const jsonData = {
        "name": "bulbasaur",
        "url": "https://pokeapi.co/api/v2/pokemon/1/"
      };
      test('should be able to parse to Pokemon', () {
        final res = Pokemon.fromJson(jsonData);
        expect(
          res,
          const Pokemon(
            name: 'bulbasaur',
            pokemonDataUrl: 'https://pokeapi.co/api/v2/pokemon/1/',
          ),
        );
      });
    });
  });
}
