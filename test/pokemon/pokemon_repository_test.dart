import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/pokemon/models/pokemon_preview.dart';
import 'package:pokedex_app/pokemon/pokemon_repository.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  group('PokemonHTTPRepository', () {
    late MockClient mockClient;
    setUp(() {
      registerFallbackValue(Uri());
      mockClient = MockClient();
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(
          'success',
          200,
        ),
      );
    });
    tearDown(() {
      reset(mockClient);
    });
    test('should be initializable', () {
      final repo = PokemonHTTPRepository(url: '123');
      expect(repo, isA<PokemonHTTPRepository>());
    });
    test('should be initializable when injected by client', () async {
      final repo = PokemonHTTPRepository(client: mockClient, url: '');
      expect(repo, isA<PokemonHTTPRepository>());
    });
    group('getPokemons', () {
      test('should have a getPokemons that returns list of pokemon previews',
          () async {
        final res = await PokemonHTTPRepository(url: '', client: mockClient)
            .getPokemons();
        expect(res, isA<List<PokemonPreview>>());
      });
      test(
          'when injected with url, should verify that the url is called within '
          'in the client get method', () async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(
            'success',
            200,
          ),
        );
        await PokemonHTTPRepository(
          client: mockClient,
          url: '/123/123',
        ).getPokemons();
        verify(() => mockClient.get(Uri.parse('/123/123'))).called(1);
      });
      test(
          'when HTTP calll returns a response code other than 200, should '
          'throw error', () async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(
            'error 400 bad request',
            400,
          ),
        );
        final res = PokemonHTTPRepository(
          client: mockClient,
          url: '',
        ).getPokemons();
        res.onError((error, stackTrace) async {
          expect(error, isA<Exception>());
          expect(error.toString(), contains('error 400 bad request'));
          return [];
        });
      });
      test(
          'when HTTP calll returns a response code of 200, should '
          'return a list of pokemon preview', () async {
        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(
            'success',
            200,
          ),
        );
        final res = await PokemonHTTPRepository(
          client: mockClient,
          url: '',
        ).getPokemons();
        expect(res, isA<List<PokemonPreview>>());
      });
    });
  });
}
