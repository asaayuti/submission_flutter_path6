import 'package:tv_series/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';

class TopRatedTvsPage extends StatefulWidget {
  const TopRatedTvsPage({super.key});

  @override
  State<TopRatedTvsPage> createState() => _TopRatedTvsPageState();
}

class _TopRatedTvsPageState extends State<TopRatedTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedTvsBloc>().add(FetchTopRatedTvs());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TvSeries')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvsBloc, TopRatedTvsState>(
          builder: (context, state) {
            if (state is TopRatedTvsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.tvs[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is TopRatedTvsError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
