import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_tvs_event.dart';
part 'now_playing_tvs_state.dart';

class NowPlayingTvsBloc extends Bloc<NowPlayingTvsEvent, NowPlayingTvsState> {
  final GetNowPlayingTvs getNowPlayingTvSeries;
  NowPlayingTvsBloc(this.getNowPlayingTvSeries) : super(NowPlayingTvsEmpty()) {
    on<FetchNowPlayingTvs>((event, emit) async {
      emit(NowPlayingTvsLoading());
      await getNowPlayingTvSeries.execute().then((result) {
        result.fold(
          (failure) => emit(NowPlayingTvsError(failure.message)),
          (tvs) => emit(NowPlayingTvsHasData(tvs)),
        );
      });
    });
  }
}
