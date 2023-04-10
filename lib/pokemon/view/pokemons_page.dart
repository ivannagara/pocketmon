import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            stretch: false,
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
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Image.asset(
                      'assets/pokeball2.png',
                      width: 200,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const _PokemonsFutureBuilderBody(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscoverPokemonFlexibleAppBar extends StatelessWidget {
  const _DiscoverPokemonFlexibleAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        'Discover Pokemons',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.white),
        textScaleFactor: 1.2,
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
        child: Image.asset(
          'assets/discover_pokemons.jpeg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class _PokemonsFutureBuilderBody extends StatelessWidget {
  const _PokemonsFutureBuilderBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PokemonPreview>>(
      future: context.read<PokemonRepository>().getPokemons(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.hasData) {
          return Expanded(
            child: GridView.builder(
              itemCount: snapshot.data?.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => Padding(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textScaleFactor: 1.2,
                            ),
                          ),
                          Image.network(
                            '',
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              return child;
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const _ErrorImagePlaceholder();
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const Center(
                                  child: FetchingIndicator(),
                                );
                              }
                            },
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          // return ListView.builder(
          //   itemCount: snapshot.data?.length,
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text(snapshot.data?[index].name ?? ''),
          //     );
          //   },
          // );
        }
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 75,
              width: 75,
              color: Colors.grey.withAlpha(100),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LottieBuilder.asset('assets/pokeball-loading.json'),
              ),
            ),
          ),
        );
        // return const FetchingIndicator();
      },
    );
  }
}

class _ErrorImagePlaceholder extends StatelessWidget {
  const _ErrorImagePlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/pokeball2.png',
        fit: BoxFit.contain,
        height: 60,
        width: 60,
      ),
    );
  }
}
