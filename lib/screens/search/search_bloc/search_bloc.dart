import 'package:canteen_frontend/models/search/search_query.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/algolia.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  Map<SearchQuery, List<User>> _searchResults = {};
  List<SearchQuery> searchHistory = [];

  SearchBloc();

  @override
  SearchState get initialState => SearchUninitialized();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchStarted) {
      yield* _mapSearchStartedToState(event);
    } else if (event is ResetSearch) {
      yield* _mapResetSearchToState();
    } else if (event is ClearSearch) {
      yield* _mapClearSearchToState();
    }
  }

  Stream<SearchState> _mapSearchStartedToState(SearchStarted event) async* {
    yield SearchLoading();
    try {
      final query = SearchQuery(
        query: event.query.toLowerCase(),
        displayQuery: event.query,
      );

      if (event.saveQuery) {
        searchHistory
            .remove(query); // Remove without checking so only one traversal
        searchHistory.add(query);
      }

      final snapshot = await AlgoliaSearch.query(event.query);

      final results = snapshot.hits
          .map((result) => User.fromAlgoliaSnapshot(result))
          .toList();

      _searchResults[query] = results;

      yield SearchCompleteShowResults(
        results: results,
        fromPreviousSearch: event.fromPreviousSearch,
      );
    } catch (error) {
      print('Search failed: $error');
      yield SearchError();
    }
  }

  Stream<SearchState> _mapResetSearchToState() async* {
    yield SearchUninitialized();
  }

  Stream<SearchState> _mapClearSearchToState() async* {
    _searchResults = {};
    searchHistory = [];
    yield SearchUninitialized();
  }
}
