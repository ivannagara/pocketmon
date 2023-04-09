import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/pokemon/models/pokemon_preview.dart';

void main() {
  group('PokemonPreview', () {
    test('should be initializablle', () {
      const res = PokemonPreview();
      expect(res, isA<PokemonPreview>());
    });
    test('should have the given properties', () {
      const res = PokemonPreview(name: 'abc', url: 'abc.com');
      expect(res.name, 'abc');
      expect(res.url, 'abc.com');
    });
  });
}
