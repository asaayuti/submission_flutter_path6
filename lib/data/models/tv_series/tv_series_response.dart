import 'package:ditonton/data/models/tv_series/tv_series_model.dart';

class TvSeriesResponse {
  List<TvSeriesModel> tvSeriesList;

  TvSeriesResponse({
    required this.tvSeriesList,
  });

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesResponse(
        tvSeriesList: List<TvSeriesModel>.from(
            json["results"].map((x) => TvSeriesModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(tvSeriesList.map((x) => x.toJson())),
      };
}
