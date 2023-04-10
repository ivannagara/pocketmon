import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';

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
        expect(res, const PokemonPreview(id: 0));
      });
      test('given json with correct, should have the json values', () {
        const jsonFile = <String, dynamic>{
          "id": 1,
          "num": "001",
          "name": "Bulbasaur",
          "img": "http://www.serebii.net/pokemongo/pokemon/001.png",
          "type": ["Grass", "Poison"],
          "height": "0.71 m",
          "weight": "6.9 kg",
          "candy": "Bulbasaur Candy",
          "candy_count": 25,
          "egg": "2 km",
          "spawn_chance": 0.69,
          "avg_spawns": 69,
          "spawn_time": "20:00",
          "multipliers": [1.58],
          "weaknesses": ["Fire", "Ice", "Flying", "Psychic"],
          "next_evolution": [
            {"num": "002", "name": "Ivysaur"},
          ]
        };
        final res = PokemonPreview.fromJson(jsonFile);
        expect(
          res,
          const PokemonPreview(
            id: 1,
            num: '001',
            name: 'Bulbasaur',
            img: 'http://www.serebii.net/pokemongo/pokemon/001.png',
            type: ['Grass', 'Poison'],
            height: '0.71 m',
            weight: '6.9 kg',
            candy: 'Bulbasaur Candy',
            candyCount: 25,
            egg: '2 km',
            spawnChance: 0.69,
            avgSpawns: 69,
            spawnTime: '20:00',
            multipliers: [1.58],
            weaknesses: ['Fire', 'Ice', 'Flying', 'Psychic'],
            nextEvolution: [
              NextEvolution(name: 'Ivysaur', num: '002'),
            ],
          ),
        );
      });
    });
  });
}
