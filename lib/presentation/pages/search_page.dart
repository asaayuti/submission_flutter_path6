import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                Provider.of<SearchNotifier>(context, listen: false)
                    .fetchSearchResults(query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Consumer<SearchNotifier>(
              builder: (context, data, child) {
                if (data.state == RequestState.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.state == RequestState.loaded) {
                  final movies = data.movieSearchResult;
                  final tvSeries = data.tvSeriesSearchResult;
                  return Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        if (movies.isNotEmpty) ...[
                          Text('Movies', style: kHeading6),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final movie = movies[index];
                              return MovieCard(movie);
                            },
                            itemCount: movies.length,
                          ),
                        ] else ...[
                          Text('Movies', style: kHeading6),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Text('No movies found'),
                            ),
                          ),
                        ],
                        if (tvSeries.isNotEmpty) ...[
                          Text('TV Series', style: kHeading6),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final tvSeriesItem = tvSeries[index];
                              return TvSeriesCard(tvSeriesItem);
                            },
                            itemCount: tvSeries.length,
                          ),
                        ] else ...[
                          Text('TV Series', style: kHeading6),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Text('No TV series found'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Movies', style: kHeading6),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Text('No movies found'),
                        ),
                      ),
                      Text('TV Series', style: kHeading6),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Text('No TV series found'),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
