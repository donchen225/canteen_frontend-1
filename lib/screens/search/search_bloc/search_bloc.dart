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
  List<String> _searchHistory = [];

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
    }
  }

  Stream<SearchState> _mapSearchStartedToState(SearchStarted event) async* {
    yield SearchLoading();
    try {
      _searchHistory.add(event.query);

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
    yield SearchTyping(
        initialQuery: event.initialQuery, searchHistory: _searchHistory);
  }

  Stream<SearchState> _mapSearchInspectUserToState(
      SearchInspectUser event) async* {
    yield SearchShowProfile(event.user);
  }

  Stream<SearchState> _mapSearchShowResultsToState() async* {
    yield SearchCompleteShowResults(
        _searchHistory.isNotEmpty ? _searchHistory.last : '', _searchResults);
  }

  // TODO: paginate results
  Stream<SearchState> _mapSearchHomeToState() async* {
    if (_latestUsers.length == 0) {
      final users = await _userRepository.getAllUsers();
      _latestUsers = users;
    }

    yield SearchUninitialized(_latestUsers);
  }
}
