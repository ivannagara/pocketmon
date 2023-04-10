import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';
import 'package:pokedex_app/pokemon/pokemon_repository.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  group('PokemonHTTPRepository', () {
    late MockClient mockClient;
    const jsonFile = '''{
      "pokemon": [
        {
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
            {
              "num": "002",
              "name": "Ivysaur"
              }
          ]
        }
      ]
    }''';
    setUp(() {
      registerFallbackValue(Uri());
      mockClient = MockClient();
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(
          jsonFile,
          200,
        ),
      );
    });
    tearDown(() {
      reset(mockClient);
    });
    test('should be initializable', () {
      final repo = PokemonHTTPRepository(hostUrl: '123', path: '');
      expect(repo, isA<PokemonHTTPRepository>());
    });
    test('should be initializable when injected by client', () async {
      final repo =
          PokemonHTTPRepository(client: mockClient, hostUrl: '', path: '');
      expect(repo, isA<PokemonHTTPRepository>());
    });
    group('getPokemons', () {
      test('should have a getPokemons that returns list of pokemon previews',
          () async {
        final res = await PokemonHTTPRepository(
          hostUrl: '',
          path: '',
          client: mockClient,
        ).getPokemons();
        expect(res, isA<List<PokemonPreview>>());
      });
      test(
          'when injected with url, should verify that the url is called within '
          'in the client get method', () async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(
            jsonFile,
            200,
          ),
        );
        await PokemonHTTPRepository(
          client: mockClient,
          hostUrl: '/123/123/',
          path: 'aaa',
        ).getPokemons();
        verify(() => mockClient.get(Uri.parse('/123/123/aaa'))).called(1);
      });
      test(
          'when HTTP call returns a response code other than 200, should '
          'throw error', () async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(
            'error 400 bad request',
            400,
          ),
        );
        final res = PokemonHTTPRepository(
          client: mockClient,
          path: '',
          hostUrl: '',
        ).getPokemons();
        res.onError((error, stackTrace) async {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('error 400 bad request'));
          return [];
        });
      });
      test('when the response is an empty string, should throw exception',
          () async {
        const jsonFile = '';
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(
            jsonFile,
            200,
          ),
        );
        final res = PokemonHTTPRepository(
          client: mockClient,
          path: '',
          hostUrl: '',
        ).getPokemons();
        res.onError((error, stackTrace) async {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('JSON body is empty'));
          return [];
        });
      });
      test(
          'when HTTP call returns a response result of empty map, should '
          'throw error', () async {
        const jsonFile = '''
{
  "count": null
}''';
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(
            jsonFile,
            200,
          ),
        );
        final res = PokemonHTTPRepository(
          client: mockClient,
          path: '',
          hostUrl: '',
        ).getPokemons();
        res.onError((error, stackTrace) async {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('Pokemons body not found'));
          return [];
        });
      });
      test(
          'when HTTP calll returns a response code of 200, should '
          'return a list of pokemon preview', () async {
        const expectedAnswer = [
          PokemonPreview(
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
        ];
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(
            jsonFile,
            200,
          ),
        );
        final res = await PokemonHTTPRepository(
          client: mockClient,
          hostUrl: '',
          path: '',
        ).getPokemons();
        expect(res, expectedAnswer);
      });
    });
  });
}
