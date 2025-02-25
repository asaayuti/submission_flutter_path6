import 'package:core/styles/text_styles.dart';
import 'package:core/utils/state_enum.dart';
import '../provider/search_notifier.dart';
import '../widgets/movie_card_list.dart';
import '../widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<SearchNotifier>().fetchSearchResults(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            Expanded(
              child: Consumer<SearchNotifier>(
                builder: (context, data, child) {
                  if (data.state == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.state == RequestState.loaded) {
                    return ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        _buildList(
                          title: 'Movies',
                          items: data.movieSearchResult,
                          itemBuilder: (item) => MovieCard(item),
                        ),
                        _buildList(
                          title: 'TV Series',
                          items: data.tvSeriesSearchResult,
                          itemBuilder: (item) => TvSeriesCard(item),
                        ),
                      ],
                    );
                  }
                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList<T>({
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
  }) {
    final filteredItems =
        items.where((item) {
          final path = (item as dynamic).posterPath;
          return path?.isNotEmpty ?? false;
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kHeading6),
        if (filteredItems.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) => itemBuilder(filteredItems[index]),
          )
        else
          _buildNoResults(),
      ],
    );
  }

  Widget _buildNoResults() => const Padding(
    padding: EdgeInsets.all(24.0),
    child: Center(child: Text('No results found')),
  );

  Widget _buildEmptyState() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildList(
        title: 'Movies',
        items: [],
        itemBuilder: (_) => const SizedBox(),
      ),
      _buildList(
        title: 'TV Series',
        items: [],
        itemBuilder: (_) => const SizedBox(),
      ),
    ],
  );
}
