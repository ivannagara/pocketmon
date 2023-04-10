import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/pokemon/models/pokemon_preview.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';
import 'package:pokedex_app/pokemon/pokemon_repository.dart';

class MockPokemonRepository extends Mock implements PokemonHTTPRepository {}

void main() {
  group('PokemonsPage', () {
    late MockPokemonRepository mockRepo;
    setUp(() {
      mockRepo = MockPokemonRepository();
      when(() => mockRepo.getPokemons()).thenAnswer((_) async => []);
    });
    tearDown(() {
      reset(mockRepo);
    });
    final page = MaterialApp(
      home: RepositoryProvider<PokemonRepository>(
        create: (context) => mockRepo,
        child: const PokemonsPageScaffold(),
      ),
    );
    testWidgets('should be initializable', (tester) async {
      await tester.pumpWidget(page);
      await tester.pump();
      expect(find.byType(PokemonsPageScaffold), findsOneWidget);
    });
    testWidgets('when repository throws error, should show error message',
        (tester) async {
      when(() => mockRepo.getPokemons())
          .thenAnswer((_) async => Future.error(Exception('lol123')));
      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
      expect(find.textContaining('lol123'), findsOneWidget);
    });
    testWidgets('when repository is loading, should show loading indicator',
        (tester) async {
      when(() => mockRepo.getPokemons())
          .thenAnswer((_) async => Future.delayed(const Duration(seconds: 10)));
      await tester.pumpWidget(page);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets(
        'when repository is returns a list of 3 pokemon previews, should'
        'show 3 list tiles that displays the pokemons name', (tester) async {
      when(() => mockRepo.getPokemons()).thenAnswer((_) async => [
            const PokemonPreview(name: 'Pikachu', url: 'abc'),
            const PokemonPreview(name: 'Raichu', url: 'abc'),
            const PokemonPreview(name: 'Charmander', url: 'abc'),
          ]);
      await tester.pumpWidget(page);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.text('Pikachu'), findsOneWidget);
      expect(find.text('Raichu'), findsOneWidget);
      expect(find.text('Charmander'), findsOneWidget);
    });
  });
}
