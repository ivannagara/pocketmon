import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/home/repository/home_repository.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';
import 'package:pokedex_app/pokemon/view/pokemon_from_poke_api/query_pokemon_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokedex App')),
      body: RepositoryProvider<HomeRepository>(
        create: (context) => HomeHTTPRepository(),
        child: Column(
          children: const [
            _PokeballLogo(),
            _NavigateToPokemonsPageButton(),
            _GoToPokemonsListPage(),
          ],
        ),
      ),
    );
  }
}

class _GoToPokemonsListPage extends StatelessWidget {
  const _GoToPokemonsListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QueryPokemonPage(),
          ),
        );
      },
      child: const Text("List Lots of Pokemons"),
    );
  }
}

class _PokeballLogo extends StatelessWidget {
  const _PokeballLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SizedBox(
          height: 120,
          width: 120,
          child: Image.asset('assets/pokeball.jpeg'),
        ),
      ),
    );
  }
}

class _NavigateToPokemonsPageButton extends StatelessWidget {
  const _NavigateToPokemonsPageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PokemonsPage(),
          ),
        );
      },
      child: const Text("Let's Get Started!"),
    );
  }
}
