part of 'query_pokemon_bloc.dart';

class QueryPokemonState extends Equatable {
  const QueryPokemonState({
    this.isLoading = false,
    this.errorMessage = '',
    this.pokemons = const <Pokemon>[],
    this.totalHasReachedMax = false,
    this.fetchStartIndex = 0,
    this.fetchSize = 25,
  });

  final List<Pokemon> pokemons;
  final bool isLoading;
  final String errorMessage;
  final bool totalHasReachedMax;
  final int fetchStartIndex;
  final int fetchSize;

  @override
  List<Object> get props => [
        pokemons,
        isLoading,
        errorMessage,
        totalHasReachedMax,
        fetchStartIndex,
        fetchSize,
      ];

  QueryPokemonState copyWith({
    List<Pokemon>? pokemons,
    bool? isLoading,
    String? errorMessage,
    bool? totalHasReachedMax,
    int? fetchStartIndex,
    int? fetchSize,
  }) {
    return QueryPokemonState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      totalHasReachedMax: totalHasReachedMax ?? this.totalHasReachedMax,
      fetchStartIndex: fetchStartIndex ?? this.fetchStartIndex,
      fetchSize: fetchSize ?? this.fetchSize,
    );
  }
}
