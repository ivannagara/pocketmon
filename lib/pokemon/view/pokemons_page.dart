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
      appBar: AppBar(
        title: const Text('Pokemons List'),
        centerTitle: true,
      ),
      body: const _PokemonsFutureBuilderBody(),
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
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data?[index].name ?? ''),
              );
            },
          );
        }
        return const FetchingIndicator();
      },
    );
  }
}
