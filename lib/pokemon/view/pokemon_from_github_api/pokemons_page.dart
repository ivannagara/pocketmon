import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/loading_indicator/loading_indicator.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';
import 'package:pokedex_app/pokemon/pokemon_repository.dart';
import 'package:pokedex_app/repositories.dart';

class PokemonsPage extends StatelessWidget {
  const PokemonsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PokemonRepository>(
      create: (context) => HTTPRepository().getPokemonRepository,
      child: const PokemonsPageScaffold(childCount: 40),
    );
  }
}

class PokemonsPageScaffold extends StatelessWidget {
  const PokemonsPageScaffold({
    Key? key,
    this.childCount,
  }) : super(key: key);

  final int? childCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      body: FutureBuilder<List<PokemonPreview>>(
        future: context.read<PokemonRepository>().getPokemonsFromGithub(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Text(snapshot.error.toString()),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) =>
                  [const _FlexibleAppBar()],
              body: Scrollbar(
                thickness: 8,
                radius: const Radius.circular(8),
                interactive: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          const _PokeballBackgroundImage(),
                          _PokemonGridViewLists(
                            childCount: childCount,
                            pokemons: snapshot.data ?? [],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const PokeballLoadingIndicator();
        },
      ),
    );
  }
}

class _PokeballBackgroundImage extends StatelessWidget {
  const _PokeballBackgroundImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      right: -50,
      child: Image.asset(
        'assets/pokeball2.png',
        width: 200,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class _PokemonGridViewLists extends StatelessWidget {
  const _PokemonGridViewLists({
    Key? key,
    required this.childCount,
    required this.pokemons,
  }) : super(key: key);

  final int? childCount;
  final List<PokemonPreview> pokemons;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: childCount ?? pokemons.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) => _PokemonsGridTile(
        pokemon: pokemons[index],
      ),
    );
  }
}

class _FlexibleAppBar extends StatelessWidget {
  const _FlexibleAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: const _AppBarBackButton(),
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      backgroundColor: Colors.transparent,
      flexibleSpace: const _DiscoverPokemonFlexibleAppBar(),
    );
  }
}

class _AppBarBackButton extends StatelessWidget {
  const _AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back',
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 25,
            width: 25,
            color: Colors.grey.withAlpha(180),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          ),
        ),
      ),
    );
  }
}

class _PokemonsGridTile extends StatelessWidget {
  const _PokemonsGridTile({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final PokemonPreview pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonDetailsPage(pokemon: pokemon),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey.shade600.withAlpha(180),
                  getGridTileColor(pokemon.type[0]).withAlpha(220),
                ],
              ),
            ),
            child: GridTile(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _TypeColoredCircleBackground(
                      type: pokemon.type[0],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 6,
                    child: Text(
                      '#${pokemon.num}',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.white.withAlpha(95),
                            fontWeight: FontWeight.bold,
                          ),
                      textScaleFactor: 0.75,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _PokemonGridTileImage(imageUrl: pokemon.img),
                  ),
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: _PokemonNameAndTypeChipsColumn(
                        pokemon: pokemon,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PokemonNameAndTypeChipsColumn extends StatelessWidget {
  const _PokemonNameAndTypeChipsColumn({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final PokemonPreview pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PokemonNameText(name: pokemon.name),
          ...getTypeChip(pokemon.type),
        ],
      ),
    );
  }
}

class _PokemonNameText extends StatelessWidget {
  const _PokemonNameText({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(
          name,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white.withAlpha(220),
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.start,
          textScaleFactor: 1,
        ),
      ),
    );
  }
}

class _TypeColoredCircleBackground extends StatelessWidget {
  const _TypeColoredCircleBackground({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(75),
      child: Container(
        height: 120,
        width: 120,
        color: getPokemonBackgroundColor(type).withAlpha(80),
      ),
    );
  }
}

class _PokemonGridTileImage extends StatelessWidget {
  const _PokemonGridTileImage({
    Key? key,
    this.imageUrl = '',
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(),
    );
  }
}

class _DiscoverPokemonFlexibleAppBar extends StatefulWidget {
  const _DiscoverPokemonFlexibleAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<_DiscoverPokemonFlexibleAppBar> createState() =>
      _DiscoverPokemonFlexibleAppBarState();
}

class _DiscoverPokemonFlexibleAppBarState
    extends State<_DiscoverPokemonFlexibleAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer _timer;

  final List<String> _backgroundImages = [
    'assets/discover-1.jpeg',
    'assets/discover-2.jpg',
    'assets/discover-3.webp',
    'assets/discover-4.jpg',
    'assets/discover-5.png',
  ];

  int _backgroundImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_backgroundImageIndex == 4) {
        setState(() {
          _backgroundImageIndex = -1;
        });
      }
      if (mounted) {
        setState(() {
          _backgroundImageIndex =
              (_backgroundImageIndex + 1) % _backgroundImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      title: FadeTransition(
        opacity: _animationController,
        child: Text(
          'Discover Pokémons \nfrom your Pocket',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
          textScaleFactor: 1.2,
        ),
      ),
      background: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: <Color>[
              Colors.blueGrey.shade300,
              Colors.transparent,
            ],
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 750),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            key: ValueKey<int>(_backgroundImageIndex),
            child: Image.asset(
              _backgroundImages[_backgroundImageIndex],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
