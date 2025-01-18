import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bwa_flutix/models/models.dart';
import 'package:bwa_flutix/services/services.dart';
import 'package:equatable/equatable.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
  }

  Future<void> _onFetchMovies(
      FetchMovies event, Emitter<MovieState> emit) async {
    try {
      List<Movie> movies = await MovieServices.getMovies(1);

      emit(MovieLoaded(
        movies: movies
            .where((element) =>
                element.title?.toLowerCase().contains('365') == false &&
                element.title?.toLowerCase().contains('bois') == false)
            .toList(),
      ));
    } catch (e) {
      emit(MovieError(message: 'Failed to fetch movies: $e'));
    }
  }
}

class MovieError extends MovieState {
  final String message;

  MovieError({required this.message});

  @override
  List<Object> get props => [message];
}
