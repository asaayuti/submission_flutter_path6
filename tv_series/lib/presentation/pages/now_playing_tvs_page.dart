import 'package:tv_series/presentation/bloc/now_playing_tvs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';

class NowPlayingTvsPage extends StatefulWidget {
  const NowPlayingTvsPage({super.key});

  @override
  State<NowPlayingTvsPage> createState() => _NowPlayingTvsPageState();
}

class _NowPlayingTvsPageState extends State<NowPlayingTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NowPlayingTvsBloc>().add(FetchNowPlayingTvs());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NowPlaying TvSeries')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvsBloc, NowPlayingTvsState>(
          builder: (context, state) {
            if (state is NowPlayingTvsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NowPlayingTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is NowPlayingTvsError) {
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
