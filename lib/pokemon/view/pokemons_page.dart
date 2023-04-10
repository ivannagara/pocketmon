import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/loading_indicator/loading_indicator.dart';
import 'package:pokedex_app/pokemon/models/pokemon_preview.dart';
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
      child: const PokemonsPageScaffold(),
    );
  }
}

class PokemonsPageScaffold extends StatelessWidget {
  const PokemonsPageScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      body: FutureBuilder<List<PokemonPreview>>(
        future: context.read<PokemonRepository>().getPokemonsFromGithubRepo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  leading: const _AppBarBackButton(),
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: const _DiscoverPokemonFlexibleAppBar(),
                )
              ],
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        const _PokeballBackgroundImage(),
                        Expanded(
                          child: GridView.builder(
                            itemCount: 15,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) => _PokemonsGridTile(
                              index: index,
                              imageUrl: snapshot.data?[index].img ?? '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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

class _AppBarBackButton extends StatelessWidget {
  const _AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 25,
          width: 25,
          color: Colors.grey.withAlpha(180),
          child: const BackButton(),
        ),
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

class _PokemonsGridTile extends StatelessWidget {
  const _PokemonsGridTile({
    Key? key,
    this.index = 0,
    this.imageUrl = '',
  }) : super(key: key);

  final int index;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: Colors.white,
          child: GridTile(
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                    textScaleFactor: 1.6,
                  ),
                ),
                Center(
                  child: _PokemonGridTileImage(imageUrl: imageUrl),
                ),
              ],
            ),
          ),
        ),
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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: Image.asset(
            _backgroundImages[_backgroundImageIndex],
            key: ValueKey<int>(_backgroundImageIndex),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
