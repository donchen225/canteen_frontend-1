import 'dart:collection';

import 'package:canteen_frontend/models/search/search_query.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/algolia.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserRepository _userRepository;
  List<User> _latestUsers = [];
  List<User> _searchResults = [];
  List<SearchQuery> _searchHistory = [];
  DoubleLinkedQueue<SearchState> _previousStates = DoubleLinkedQueue();

  SearchBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SearchState get initialState =>
      SearchLoading(); // TODO: change this to SearchUninitialized?

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchStarted) {
      yield* _mapSearchStartedToState(event);
    } else if (event is EnterSearchQuery) {
      yield* _mapEnterSearchQueryToState(event);
    } else if (event is SearchInspectUser) {
      yield* _mapSearchInspectUserToState(event);
    } else if (event is SearchShowResults) {
      yield* _mapSearchShowResultsToState();
    } else if (event is SearchHome) {
      yield* _mapSearchHomeToState();
    } else if (event is SearchPreviousState) {
      yield* _mapSearchPreviousStateToState();
    }
  }

  Stream<SearchState> _mapSearchStartedToState(SearchStarted event) async* {
    _previousStates.add(state);
    yield SearchLoading();
    try {
      final query = SearchQuery(
        query: event.query.toLowerCase(),
        displayQuery: event.query,
      );
      final exists = _searchHistory
          .remove(query); // Remove without checking so only one traversal
      print(exists);
      _searchHistory.add(query);

      final snapshot = await AlgoliaSearch.query(event.query);
      final results = snapshot.hits
          .map((result) => User.fromAlgoliaSnapshot(result))
          .toList();

      _searchResults = results;

      yield SearchCompleteShowResults(event.query, results);
    } catch (e) {
      print(e);
      print('SEARCH FAILED');
      yield SearchError();
    }
  }

  Stream<SearchState> _mapEnterSearchQueryToState(
      EnterSearchQuery event) async* {
    _previousStates.add(state);
    yield SearchTyping(
        initialQuery: event.initialQuery,
        searchHistory: _searchHistory
            .map((q) => q.displayQuery)
            .toList()
            .reversed
            .toList());
  }

  Stream<SearchState> _mapSearchInspectUserToState(
      SearchInspectUser event) async* {
    _previousStates.add(state);
    yield SearchShowProfile(event.user);
  }

  Stream<SearchState> _mapSearchShowResultsToState() async* {
    _previousStates.add(state);
    yield SearchCompleteShowResults(
        _searchHistory.isNotEmpty ? _searchHistory.last : '', _searchResults);
  }

  // TODO: paginate results
  Stream<SearchState> _mapSearchHomeToState() async* {
    _previousStates.clear();

    if (_latestUsers.length == 0) {
      final users = await _userRepository.getAllUsers();
      _latestUsers = users;
    }

    yield SearchUninitialized(_latestUsers);
  }

  Stream<SearchState> _mapSearchPreviousStateToState() async* {
    print(_previousStates);
    try {
      final state = _previousStates.removeLast();
      print(state);
      yield state;
    } catch (e) {
      print('Could not return to previous state: $e');
    }
  }
}
