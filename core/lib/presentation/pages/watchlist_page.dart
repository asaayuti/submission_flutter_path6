import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tv_series/presentation/widgets/tv_series_card_list.dart';

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
      context.read<WatchlistTvBloc>().add(FetchWatchlistTvs());
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
    context.read<WatchlistTvBloc>().add(FetchWatchlistTvs());
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
    return BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
      builder: (context, state) {
        if (state is WatchlistTvEmpty) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WatchlistTvLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tv = state.tvs[index];
              return TvSeriesCard(tv);
            },
            itemCount: state.tvs.length,
          );
        } else if (state is WatchlistTvError) {
          return Center(
            key: Key('error_message_tvs'),
            child: Text(state.message),
          );
        } else {
          return Container();
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
