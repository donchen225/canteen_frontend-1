import 'package:canteen_frontend/models/search/search_query.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/algolia.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<User> _latestUsers = [];
  List<User> _searchResults = [];
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
      searchHistory
          .remove(query); // Remove without checking so only one traversal
      searchHistory.add(query);

      final snapshot = await AlgoliaSearch.query(event.query);

      final results = snapshot.hits
          .map((result) => User.fromAlgoliaSnapshot(result))
          .toList();

      _searchResults = results;

      yield SearchCompleteShowResults(results);
    } catch (error) {
      print('Search failed: $error');
      yield SearchError();
    }
  }

  Stream<SearchState> _mapClearSearchToState() async* {
    _latestUsers = [];
    _searchResults = [];
    searchHistory = [];
    yield SearchUninitialized();
  }
}
