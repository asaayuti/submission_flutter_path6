import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tvs.dart';

part 'popular_tvs_event.dart';
part 'popular_tvs_state.dart';

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs getPopularTvs;
  PopularTvsBloc(this.getPopularTvs) : super(PopularTvsEmpty()) {
    on<FetchPopularTvs>((event, emit) async {
      emit(PopularTvsLoading());
      await getPopularTvs.execute().then((result) {
        result.fold(
          (failure) => emit(PopularTvsError(failure.message)),
          (tvs) => emit(PopularTvsHasData(tvs)),
        );
      });
    });
  }
}
