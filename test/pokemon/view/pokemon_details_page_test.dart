import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';

void main() {
  group('PokemonsPage', () {
    const page = MaterialApp(
      home: PokemonDetailsPage(
        pokemon: PokemonPreview(id: 1),
      ),
    );
    testWidgets('should be initializable', (tester) async {
      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
      expect(find.byType(PokemonDetailsPage), findsOneWidget);
    });
    testWidgets('given a pokemon, should display the pokemons information',
        (tester) async {
      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
      expect(find.byType(PokemonDetailsPage), findsOneWidget);
    });
  });
}
