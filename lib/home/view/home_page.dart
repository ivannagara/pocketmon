import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/home/repository/home_repository.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Pokedex App')),
        body: RepositoryProvider<HomeRepository>(
          create: (context) => HomeHTTPRepository(),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PokemonsPage(),
                    ),
                  );
                },
                child: const Text('Load Pokemons'),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(index.toString()),
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchPokemonTextField extends StatelessWidget {
  const _SearchPokemonTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('searchPokemonField'),
      decoration: InputDecoration(
          hintText: 'e.g. Pikachu, Charmander',
          label: Row(
            children: const [
              Icon(Icons.search),
              SizedBox(width: 4),
              Text('Search Pokemons'),
            ],
          )),
    );
  }
}
