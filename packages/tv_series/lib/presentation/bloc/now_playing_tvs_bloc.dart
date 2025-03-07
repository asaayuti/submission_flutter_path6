import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tvs.dart';

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
