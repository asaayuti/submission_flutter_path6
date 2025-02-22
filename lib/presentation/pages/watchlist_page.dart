import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series/watchlist_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';

  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<WatchlistMovieNotifier>(
        context,
        listen: false,
      ).fetchWatchlistMovies();
      Provider.of<WatchlistTvSeriesNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTvSeries();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(
      context,
      listen: false,
    ).fetchWatchlistMovies();
    Provider.of<WatchlistTvSeriesNotifier>(
      context,
      listen: false,
    ).fetchWatchlistTvSeries();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
          bottom: TabBar(tabs: [Tab(text: 'Movies'), Tab(text: 'TV Series')]),
        ),
        body: TabBarView(
          children: [_buildWatchlistMovies(), _buildWatchlistTvs()],
        ),
      ),
    );
  }

  Widget _buildWatchlistMovies() {
    return Consumer<WatchlistMovieNotifier>(
      builder: (context, data, child) {
        if (data.watchlistState == RequestState.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (data.watchlistState == RequestState.loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = data.watchlistMovies[index];
              return MovieCard(movie);
            },
            itemCount: data.watchlistMovies.length,
          );
        } else {
          return Center(
            key: Key('error_message_movies'),
            child: Text(data.message),
          );
        }
      },
    );
  }

  Widget _buildWatchlistTvs() {
    return Consumer<WatchlistTvSeriesNotifier>(
      builder: (context, data, child) {
        if (data.watchlistState == RequestState.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (data.watchlistState == RequestState.loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tv = data.watchlistTvSeries[index];
              return TvSeriesCard(tv);
            },
            itemCount: data.watchlistTvSeries.length,
          );
        } else {
          return Center(
            key: Key('error_message_tvs'),
            child: Text(data.message),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
