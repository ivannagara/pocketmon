import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedex_app/pokemon/pokemon.dart';
import 'package:pokedex_app/pokemon/pokemon_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'query_pokemon_event.dart';
part 'query_pokemon_state.dart';

const _throttleDuration = Duration(milliseconds: 400);
const _fetchLimit = 25;

class QueryPokemonBloc extends Bloc<QueryPokemonEvent, QueryPokemonState> {
  QueryPokemonBloc({
    required this.pokemonRepository,
  }) : super(const QueryPokemonState()) {
    on<QueryPokemonEvent>((event, emit) {});
    on<FetchPokemonWithPaginationEvent>(
      _fetchPaginatedPokemonData,
      transformer: _throttleDroppable(_throttleDuration),
    );
  }

  final PokemonRepository pokemonRepository;

  Future<void> _fetchPaginatedPokemonData(
    FetchPokemonWithPaginationEvent event,
    Emitter<QueryPokemonState> emit,
  ) async {
    if (state.totalHasReachedMax) return;
    try {
      emit(
        state.copyWith(
          isLoading: true,
          fetchSize: _fetchLimit,
        ),
      );
      final fetchedPokemons = await pokemonRepository.getPokemonsFromPokeApi(
        queryStartIndex: state.fetchStartIndex,
        querySize: state.fetchSize,
      );

      final hasReachedMax = fetchedPokemons.length < state.fetchSize;

      emit(
        state.copyWith(
          pokemons: List.of(state.pokemons)..addAll(fetchedPokemons),
          isLoading: false,
          totalHasReachedMax: hasReachedMax,
          fetchStartIndex: hasReachedMax
              ? state.fetchStartIndex
              : state.fetchStartIndex + state.fetchSize,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}
