import 'package:tv_series/presentation/bloc/popular_tvs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';

class PopularTvsPage extends StatefulWidget {
  const PopularTvsPage({super.key});

  @override
  State<PopularTvsPage> createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularTvsBloc>().add(FetchPopularTvs());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular TvSeries')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvsBloc, PopularTvsState>(
          builder: (context, state) {
            if (state is PopularTvsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PopularTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is PopularTvsError) {
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
