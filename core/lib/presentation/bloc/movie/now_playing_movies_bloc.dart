import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  NowPlayingMoviesBloc(this.getNowPlayingMovies)
    : super(NowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(NowPlayingMoviesLoading());
      await getNowPlayingMovies.execute().then((result) {
        result.fold(
          (failure) => emit(NowPlayingMoviesError(failure.message)),
          (movies) => emit(NowPlayingMoviesHasData(movies)),
        );
      });
    });
  }
}
