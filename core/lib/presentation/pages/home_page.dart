import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/movie/now_playing_movies_bloc.dart';
import 'package:core/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:core/presentation/bloc/movie/top_rated_movies_bloc.dart';
import 'package:core/presentation/bloc/tv_series/now_playing_tvs_bloc.dart';
import 'package:core/presentation/bloc/tv_series/popular_tvs_bloc.dart';
import 'package:core/presentation/bloc/tv_series/top_rated_tvs_bloc.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie/movie.dart';
import '../../domain/entities/tv_series/tv_series.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());
        context.read<PopularMoviesBloc>().add(FetchPopularMovies());
        context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies());

        context.read<NowPlayingTvsBloc>().add(FetchNowPlayingTvs());
        context.read<PopularTvsBloc>().add(FetchPopularTvs());
        context.read<TopRatedTvsBloc>().add(FetchTopRatedTvs());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, watchlistRoute);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, aboutRoute);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchRoute);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Movies', style: kHeading5),
              Text('Now Playing', style: kHeading6),
              BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                builder: (context, state) {
                  if (state is NowPlayingMoviesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NowPlayingMoviesHasData) {
                    return MovieList(state.movies);
                  } else if (state is NowPlayingMoviesError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, popularMoviesRoute),
              ),
              BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                builder: (context, state) {
                  if (state is PopularMoviesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PopularMoviesHasData) {
                    return MovieList(state.movies);
                  } else if (state is PopularMoviesError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),

              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(context, topRatedMoviesRoute),
              ),
              BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                builder: (context, state) {
                  if (state is TopRatedMoviesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedMoviesLoaded) {
                    return MovieList(state.movies);
                  } else if (state is TopRatedMoviesError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),
              Text('Tv Series', style: kHeading5),
              _buildSubHeading(
                title: 'Now Playing',
                onTap:
                    () => Navigator.pushNamed(context, nowPlayingTvSeriesRoute),
              ),
              BlocBuilder<NowPlayingTvsBloc, NowPlayingTvsState>(
                builder: (context, state) {
                  if (state is NowPlayingTvsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NowPlayingTvsHasData) {
                    return TvSeriesList(state.tvSeries);
                  } else if (state is NowPlayingTvsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, popularTvSeriesRoute),
              ),
              BlocBuilder<PopularTvsBloc, PopularTvsState>(
                builder: (context, state) {
                  if (state is PopularTvsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PopularTvsHasData) {
                    return TvSeriesList(state.tvSeries);
                  } else if (state is PopularTvsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap:
                    () => Navigator.pushNamed(context, topRatedTvSeriesRoute),
              ),
              BlocBuilder<TopRatedTvsBloc, TopRatedTvsState>(
                builder: (context, state) {
                  if (state is TopRatedTvsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedTvsHasData) {
                    return TvSeriesList(state.tvs);
                  } else if (state is TopRatedTvsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  movieDetailRoute,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  tvSeriesDetailRoute,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
