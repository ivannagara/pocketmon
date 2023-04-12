import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';

void main() {
  group('PokemonsPage', () {
    const page = MaterialApp(
      home: PokemonDetailsPage(
        pokemon: PokemonPreview(
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
            NextEvolution(name: 'Ivyslash', num: '003'),
          ],
        ),
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
      expect(find.textContaining('Bulbasaur'), findsOneWidget);
      expect(find.textContaining('001'), findsOneWidget);
      expect(find.byType(Icon), findsWidgets);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.byType(LinearPercentIndicator), findsNWidgets(4));
      expect(find.textContaining('HP'), findsOneWidget);
      expect(find.textContaining('Attack'), findsOneWidget);
      expect(find.textContaining('Defense'), findsOneWidget);
      expect(find.textContaining('Spawn Chance'), findsOneWidget);
    });
    testWidgets(
        'when a pokemon has next evolutions, should show the evolutions',
        (tester) async {
      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
      expect(find.textContaining('Next Evolution'), findsOneWidget);
      expect(find.textContaining('#002'), findsOneWidget);
      expect(find.textContaining('Ivysaur'), findsOneWidget);
      expect(find.textContaining('#003'), findsOneWidget);
      expect(find.textContaining('Ivyslash'), findsOneWidget);
    });
  });
}
