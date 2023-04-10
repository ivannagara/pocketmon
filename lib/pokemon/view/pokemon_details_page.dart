import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokedex_app/loading_indicator/loading_indicator.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({
    super.key,
    required this.pokemon,
  });

  final PokemonPreview pokemon;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                _PokemonImageBackgroundColor(
                  height: height,
                  type: pokemon.type.isNotEmpty ? pokemon.type[0] : '',
                ),
                Positioned(
                  top: height * 0.2,
                  left: width * 0.3,
                  child: SizedBox(
                    height: width * 0.4,
                    width: width * 0.4,
                    child: Image.asset('assets/pokeball2.png'),
                  ),
                ),
                Positioned(
                  top: height * 0.07,
                  right: width * 0.05,
                  child: Text(
                    '#${pokemon.num}',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white.withAlpha(80),
                          fontWeight: FontWeight.bold,
                        ),
                    textScaleFactor: 1.6,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: _PokemonInfoSection(
                    height: height,
                    width: width,
                    pokemon: pokemon,
                  ),
                ),
                Positioned(
                  top: height * 0.2,
                  left: width * 0.25,
                  child: _PokemonImage(
                    width: width,
                    img: pokemon.img,
                  ),
                ),
                Positioned(
                  top: height * 0.07,
                  left: width * 0.005,
                  child: const BackButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PokemonImageBackgroundColor extends StatelessWidget {
  const _PokemonImageBackgroundColor({
    Key? key,
    required this.height,
    required this.type,
  }) : super(key: key);

  final double height;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            getGridTileColor(type),
            Colors.black,
          ],
        ),
      ),
    );
  }
}

class _PokemonInfoSection extends StatelessWidget {
  const _PokemonInfoSection({
    Key? key,
    required this.height,
    required this.width,
    required this.pokemon,
  }) : super(key: key);

  final double height;
  final double width;
  final PokemonPreview pokemon;

  @override
  Widget build(BuildContext context) {
    final spawnChance = Random().nextDouble();
    return Container(
      height: height * 0.6,
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pokemon.name,
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(thickness: 0.5),
          ),
          Text(
            'Type',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.black.withAlpha(200),
                  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            children: [
              ...getTypeChip(pokemon.type)
                  .map(
                    (chip) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: chip,
                    ),
                  )
                  .toList(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Spawn Chance'),
              const SizedBox(width: 4),
              Text(
                '${(spawnChance * 100).toStringAsFixed(1)}%',
              ),
              const SizedBox(width: 4),
              LinearPercentIndicator(
                width: 100.0,
                lineHeight: 8.0,
                barRadius: const Radius.circular(6),
                animation: true,
                backgroundColor: Colors.grey.shade200,
                progressColor: Colors.green,
                percent: spawnChance,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PokemonImage extends StatelessWidget {
  const _PokemonImage({
    Key? key,
    required this.width,
    required this.img,
  }) : super(key: key);

  final double width;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: width * 0.5,
        width: width * 0.5,
        child: Image.network(
          img,
          scale: 0.5,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return child;
          },
          errorBuilder: (context, error, stackTrace) => Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Card(
                color: Colors.grey.shade100.withAlpha(200),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Error Fetching Image'),
                ),
              ),
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const Center(
                child: PokeballLoadingIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
