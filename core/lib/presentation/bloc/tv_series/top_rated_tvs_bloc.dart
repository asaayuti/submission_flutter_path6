import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tvs_event.dart';
part 'top_rated_tvs_state.dart';

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;
  TopRatedTvsBloc(this.getTopRatedTvs) : super(TopRatedTvsInitial()) {
    on<FetchTopRatedTvs>((event, emit) async {
      emit(TopRatedTvsLoading());
      final result = await getTopRatedTvs.execute();
      result.fold(
        (failure) => emit(TopRatedTvsError(failure.message)),
        (movies) => emit(TopRatedTvsHasData(movies)),
      );
    });
  }
}
