import 'package:about/about_page.dart';
import 'package:movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:core/presentation/pages/home_page.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_series/presentation/pages/now_playing_tvs_page.dart';
import 'package:tv_series/presentation/pages/popular_tvs_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';
import 'package:core/presentation/pages/watchlist_page.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/routes.dart';
import 'package:core/utils/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<SearchBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingTvsBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvsBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvsBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case popularMoviesRoute:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case topRatedMoviesRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case movieDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case nowPlayingTvSeriesRoute:
              return CupertinoPageRoute(builder: (_) => NowPlayingTvsPage());
            case popularTvSeriesRoute:
              return CupertinoPageRoute(builder: (_) => PopularTvsPage());
            case topRatedTvSeriesRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedTvsPage());
            case tvSeriesDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case searchRoute:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case watchlistRoute:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case aboutRoute:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
