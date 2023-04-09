import 'package:flutter/material.dart';

class PokemonsPage extends StatelessWidget {
  const PokemonsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemons'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
