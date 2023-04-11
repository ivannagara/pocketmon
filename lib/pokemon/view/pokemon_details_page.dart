import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
                  top: height * 0.15,
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
                    textScaleFactor: 1.4,
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
                  top: height * 0.125,
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
    final attack = Random().nextDouble();
    final hp = Random().nextDouble();
    final def = Random().nextDouble();
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
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(thickness: 0.5),
          ),
          Scrollbar(
            radius: const Radius.circular(6),
            thickness: 6,
            thumbVisibility: false,
            interactive: true,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black.withAlpha(220),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      ...getTypeChip(pokemon.type, showTypeText: true)
                          .map(
                            (chip) => Padding(
                              padding: const EdgeInsets.only(right: 18),
                              child: chip,
                            ),
                          )
                          .toList(),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Base Stats',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black.withAlpha(220),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _PokemonStatusNameAndLinearBarRow(
                    status: attack,
                    statusName: 'Attack',
                    baseStatsValue: 120,
                  ),
                  const SizedBox(height: 4),
                  _PokemonStatusNameAndLinearBarRow(
                    status: hp,
                    statusName: 'HP',
                    baseStatsValue: 150,
                  ),
                  const SizedBox(height: 4),
                  _PokemonStatusNameAndLinearBarRow(
                    status: def,
                    statusName: 'Defense',
                    baseStatsValue: 120,
                  ),
                  const SizedBox(height: 4),
                  _PokemonStatusNameAndLinearBarRow(
                    status: spawnChance,
                    statusName: 'Spawn Chance',
                    isPercentage: true,
                  ),
                  if (pokemon.nextEvolution.isNotEmpty)
                    _NextEvolutionsSection(evolutions: pokemon.nextEvolution),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextEvolutionsSection extends StatelessWidget {
  const _NextEvolutionsSection({
    Key? key,
    required this.evolutions,
  }) : super(key: key);

  final List<NextEvolution> evolutions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text(
          'Next Evolution',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black.withAlpha(220),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ..._getNextEvolution(evolutions),
      ],
    );
  }
}

class _PokemonStatusNameAndLinearBarRow extends StatelessWidget {
  const _PokemonStatusNameAndLinearBarRow({
    Key? key,
    required this.status,
    this.baseStatsValue = 100,
    required this.statusName,
    this.isPercentage = false,
  }) : super(key: key);

  final double status;
  final String statusName;
  final num baseStatsValue;
  final bool isPercentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            statusName,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 50,
          child: Text(
            isPercentage
                ? '${(status * 100).toStringAsFixed(1)}%'
                : (status * baseStatsValue).toStringAsFixed(1),
          ),
        ),
        const SizedBox(width: 4),
        _LinearStatusBar(percentage: status),
      ],
    );
  }
}

class _LinearStatusBar extends StatelessWidget {
  const _LinearStatusBar({
    Key? key,
    required this.percentage,
  }) : super(key: key);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: 120,
      lineHeight: 12,
      barRadius: const Radius.circular(6),
      animation: true,
      backgroundColor: Colors.grey.shade300,
      progressColor: _getStatusBarColor(percentage),
      percent: percentage,
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
        child: CachedNetworkImage(
          imageUrl: img,
          errorWidget: (context, url, error) {
            return Center(
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
            );
          },
        ),
      ),
    );
  }
}

Color _getStatusBarColor(double fraction) {
  if (fraction < 0.1) {
    return Colors.red.shade900;
  }
  if (fraction < 0.2) {
    return Colors.red.shade500;
  }
  if (fraction < 0.3) {
    return Colors.orange.shade800;
  }
  if (fraction < 0.4) {
    return Colors.orange.shade400;
  }
  if (fraction < 0.5) {
    return Colors.yellow.shade500;
  }
  if (fraction < 0.6) {
    return Colors.lime.shade600;
  }
  if (fraction < 0.8) {
    return Colors.green.shade600;
  }
  if (fraction <= 1) {
    return Colors.green.shade800;
  }
  return Colors.blueGrey;
}

List<Widget> _getNextEvolution(List<NextEvolution> evolutions) {
  var lists = <Widget>[];
  if (evolutions.isEmpty) return [];
  for (var i = 0; i < evolutions.length; i++) {
    lists.add(Row(
      children: [
        Card(
          color: Colors.grey.withAlpha(150),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              '#${evolutions[i].num}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          evolutions[i].name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textScaleFactor: 1.1,
        ),
      ],
    ));
  }
  return lists;
}
