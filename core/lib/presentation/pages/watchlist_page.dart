import 'package:core/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../provider/tv_series/watchlist_tv_series_notifier.dart';
import '../widgets/movie_card_list.dart';
import '../widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
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
      context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
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
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
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
    return BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
      builder: (context, state) {
        if (state is WatchlistMovieEmpty) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WatchlistMovieLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return MovieCard(movie);
            },
            itemCount: state.movies.length,
          );
        } else if (state is WatchlistMovieError) {
          return Center(
            key: Key('error_message_movies'),
            child: Text(state.message),
          );
        } else {
          return Container();
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
