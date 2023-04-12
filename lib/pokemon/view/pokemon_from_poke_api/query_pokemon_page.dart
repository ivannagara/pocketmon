import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/loading_indicator/loading_indicator.dart';
import 'package:pokedex_app/pokemon/bloc/query_pokemon_bloc/query_pokemon_bloc.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';
import 'package:pokedex_app/pokemon/pokemon_repository.dart';
import 'package:pokedex_app/repositories.dart';

class QueryPokemonPage extends StatelessWidget {
  const QueryPokemonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PokemonRepository>(
      create: (context) => HTTPRepository().getPokemonRepository,
      child: BlocProvider<QueryPokemonBloc>(
        create: (context) => QueryPokemonBloc(
          pokemonRepository: context.read<PokemonRepository>(),
        )..add(const FetchPokemonWithPaginationEvent()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pokemons List'),
            centerTitle: true,
          ),
          body: const QueryPokemonPageBody(),
        ),
      ),
    );
  }
}

class QueryPokemonPageBody extends StatefulWidget {
  const QueryPokemonPageBody({super.key});

  @override
  State<QueryPokemonPageBody> createState() => _QueryPokemonPageBodyState();
}

class _QueryPokemonPageBodyState extends State<QueryPokemonPageBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueryPokemonBloc, QueryPokemonState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        }

        final pokemons = state.pokemons;

        if (pokemons.isEmpty && !state.isLoading) {
          return const Center(
            child: Text(
              'No Pokemon fetched.',
              key: Key('emptyPokemonListText'),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: Scrollbar(
                thickness: 6,
                controller: _scrollController,
                radius: const Radius.circular(12),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.totalHasReachedMax
                      ? pokemons.length
                      : pokemons.length + 1,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index >= pokemons.length) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: PokeballLoadingIndicator(),
                      );
                    }
                    final pokemon = pokemons[index];
                    return PokemonTile(
                      key: Key(index.toString()),
                      pokemon: pokemon,
                      index: index,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context
          .read<QueryPokemonBloc>()
          .add(const FetchPokemonWithPaginationEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.95);
  }
}

class PokemonTile extends StatelessWidget {
  const PokemonTile({
    super.key,
    required this.pokemon,
    required this.index,
  });

  final Pokemon pokemon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.blueGrey.shade50,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const _PokemonProfileImage(
          profileImageUrl: '',
        ),
      ),
      title: Text(
        pokemon.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(index.toString()),
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      onTap: () {
        // Navigator.of(context)
        //     .push(QueriedPokemonDetailsPage.route(pokemonDataUrl));
      },
    );
  }
}

class _PokemonProfileImage extends StatelessWidget {
  const _PokemonProfileImage({
    required this.profileImageUrl,
  });

  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Container(),
      // CachedNetworkImage(
      //   placeholder: (context, url) => Container(),
      //   imageUrl: profileImageUrl,
      //   fit: BoxFit.cover,
      // ),
    );
  }
}
