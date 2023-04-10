import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/pokemon/models/pokemon_preview.dart';

void main() {
  group('PokemonPreview', () {
    test('should be initializablle', () {
      const res = PokemonPreview(id: 1);
      expect(res, isA<PokemonPreview>());
    });
    test('should have the given properties', () {
      const res = PokemonPreview(id: 1, name: 'abc');
      expect(res.name, 'abc');
    });
    group('Equatable', () {
      test('should not be equal', () {
        const res1 = PokemonPreview(name: 'abc', id: 1);
        const res2 = PokemonPreview(name: 'aaa', id: 1);
        expect(res1, isNot(equals(res2)));
      });
      test('should be equal', () {
        const res1 = PokemonPreview(name: 'abc', id: 1);
        const res2 = PokemonPreview(name: 'abc', id: 1);
        expect(res1, equals(res2));
      });
    });
    group('fromJson', () {
      test(
          'given an empty map of json, should return empty pokemonPreview '
          'model', () {
        final res = PokemonPreview.fromJson(const {});
        expect(res, const PokemonPreview(id: 0));
      });
      test('given empty json, should give default values', () {
        const jsonFile = <String, dynamic>{};
        final res = PokemonPreview.fromJson(jsonFile);
        expect(res, const PokemonPreview(id: 1));
      });
      test('given json with correct, should have the json values', () {
        const jsonFile = <String, dynamic>{
          'name': 'Charmander',
          'url': 'url.com'
        };
        final res = PokemonPreview.fromJson(jsonFile);
        expect(res, const PokemonPreview(name: 'Charmander', id: 1));
      });
    });
  });
}
