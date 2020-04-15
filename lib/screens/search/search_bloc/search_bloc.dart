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
  int _currentIndex = 0;

  SearchBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SearchState get initialState => SearchLoading();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchStarted) {
      yield* _mapSearchStartedToState(event);
    } else if (event is SearchHome) {
      yield* _mapSearchHomeToState();
    } else if (event is SearchInspectUser) {
      yield* _mapSearchInspectUserToState(event);
    } else if (event is SearchNextUser) {
      yield* _mapSearchNextUserToState();
    }
  }

  Stream<SearchState> _mapSearchStartedToState(SearchStarted event) async* {
    yield SearchLoading();
    try {
      _searchResults = [];
      _currentIndex = 0;

      final snapshot = await AlgoliaSearch.query(event.query);
      final results = snapshot.hits
          .map((result) => User.fromAlgoliaSnapshot(result))
          .toList();
      print(results);

      if (results.length == 0) {
        yield SearchCompleteNoResults();
      } else {
        _searchResults = results;
        yield SearchShowProfile(_searchResults[_currentIndex], true);
      }
    } catch (e) {
      print(e);
      print('SEARCH FAILED');
      yield SearchCompleteNoResults();
    }
  }

  // TODO: paginate results
  Stream<SearchState> _mapSearchHomeToState() async* {
    if (_latestUsers.length == 0) {
      final users = await _userRepository.getAllUsers();
      _latestUsers = users;
    }

    yield SearchUninitialized(_latestUsers);
  }

  Stream<SearchState> _mapSearchInspectUserToState(
      SearchInspectUser event) async* {
    yield SearchShowProfile(event.user, false);
  }

  Stream<SearchState> _mapSearchNextUserToState() async* {
    yield SearchLoading();
    _currentIndex += 1;

    if (_currentIndex < _searchResults.length) {
      yield SearchShowProfile(_searchResults[_currentIndex], true);
    } else {
      yield SearchResultsEnd();
    }
  }
}
