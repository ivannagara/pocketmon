import 'package:equatable/equatable.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';

class PokemonPreview extends Equatable {
  const PokemonPreview({
    required this.id,
    this.name = '',
    this.num = '',
    this.img = '',
    this.type = const [],
    this.height = '',
    this.weight = '',
    this.candy = '',
    this.candyCount = 0,
    this.egg = '',
    this.spawnChance = 0,
    this.avgSpawns = 0,
    this.spawnTime = '',
    this.multipliers = const [],
    this.weaknesses = const [],
    this.nextEvolution = const [],
  });

  factory PokemonPreview.fromJson(Map<String, dynamic> json) {
    final List<NextEvolution> nextEvolutionList;

    final name = json['name'] as String?;
    final num = json['num'] as String?;
    final id = json['id'] as int?;
    final img = json['img'] as String?;
    final type = json['type'].cast<String>();
    final height = json['height'] as String?;
    final weight = json['weight'] as String?;
    final candy = json['candy'] as String?;
    final candyCount = json['candy_count'] as int?;
    final egg = json['egg'] as String?;
    final spawnChance = json['spawn_chance'].toString();
    final avgSpawns = json['avg_spawns'].toString();
    final spawnTime = json['spawn_time'] as String?;
    final multipliers = json['multipliers'] as List<dynamic>?;
    final weaknesses = json['weaknesses'] as List<dynamic>?;
    final nextEvolution = json['next_evolution'] as List<dynamic>?;

    final castedSpawnChance = double.tryParse(
      spawnChance.isNotEmpty ? spawnChance : '0',
    );

    final castedAvgSpawns = double.tryParse(
      avgSpawns.isNotEmpty ? avgSpawns : '0',
    );

    final multipliersList = multipliers != null
        ? multipliers.map((e) => e as double).toList()
        : <double>[];

    final weaknessesList = weaknesses != null
        ? weaknesses.map((e) => e as String).toList()
        : <String>[];

    if (nextEvolution != null) {
      nextEvolutionList = (nextEvolution)
          .map((e) => NextEvolution.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      nextEvolutionList = [];
    }

    return PokemonPreview(
      id: id ?? 0,
      name: name ?? '',
      num: num ?? '',
      img: img ?? '',
      type: type ?? <String>[],
      height: height ?? '',
      weight: weight ?? '',
      candy: candy ?? '',
      candyCount: candyCount ?? 0,
      egg: egg ?? '',
      spawnChance: castedSpawnChance ?? 0,
      avgSpawns: castedAvgSpawns ?? 0,
      spawnTime: spawnTime ?? '',
      multipliers: multipliersList,
      weaknesses: weaknessesList,
      nextEvolution: nextEvolutionList,
    );
  }

  final int id;
  final String num;
  final String name;
  final String img;
  final List<String> type;
  final String height;
  final String weight;
  final String candy;
  final int candyCount;
  final String egg;
  final double spawnChance;
  final double avgSpawns;
  final String spawnTime;
  final List<double> multipliers;
  final List<String> weaknesses;
  final List<NextEvolution> nextEvolution;

  @override
  List<Object?> get props => [
        id,
        name,
        num,
        img,
        type,
        height,
        weight,
        candy,
        candyCount,
        egg,
        spawnChance,
        avgSpawns,
        spawnTime,
        multipliers,
        weaknesses,
        nextEvolution,
      ];
}
