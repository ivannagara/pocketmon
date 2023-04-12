part of 'query_pokemon_bloc.dart';

abstract class QueryPokemonEvent extends Equatable {
  const QueryPokemonEvent();

  @override
  List<Object> get props => [];
}
class FetchPokemonWithPaginationEvent extends QueryPokemonEvent {
  const FetchPokemonWithPaginationEvent();
}
