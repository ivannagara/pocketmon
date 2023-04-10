import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';

void main() {
  group('NextEvolution', () {
    test('should be initializablle', () {
      const res = NextEvolution();
      expect(res, isA<NextEvolution>());
    });
    test('should have the given properties', () {
      const res = NextEvolution(num: '1', name: 'abc');
      expect(res.name, 'abc');
      expect(res.num, '1');
    });
    group('Equatable', () {
      test('should not be equal', () {
        const res1 = NextEvolution(name: 'abc');
        const res2 = NextEvolution(name: 'aaa');
        expect(res1, isNot(equals(res2)));
      });
      test('should be equal', () {
        const res1 = NextEvolution(name: 'abc', num: '1');
        const res2 = NextEvolution(name: 'abc', num: '1');
        expect(res1, equals(res2));
      });
    });
    group('fromJson', () {
      test(
          'given an empty map of json, should return empty NextEvolution '
          'model', () {
        final res = NextEvolution.fromJson(const {});
        expect(res, const NextEvolution());
      });
      test('given empty json, should give default values', () {
        const jsonFile = <String, dynamic>{};
        final res = NextEvolution.fromJson(jsonFile);
        expect(res, const NextEvolution());
      });
      test('given json with correct, should have the json values', () {
        const jsonFile = <String, dynamic>{"num": "002", "name": "Ivysaur"};
        final res = NextEvolution.fromJson(jsonFile);
        expect(res, const NextEvolution(name: 'Ivysaur', num: '002'));
      });
    });
  });
}
