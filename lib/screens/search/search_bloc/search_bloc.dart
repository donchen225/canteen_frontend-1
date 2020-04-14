import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/algolia.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserRepository _userRepository;
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
    } else if (event is SearchCleared) {
      yield* _mapSearchClearedToState();
    } else if (event is SearchInspectUser) {
      yield* _mapSearchInspectUserToState(event.user);
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
        yield SearchCompleteNoResults('No results found.');
      } else {
        _searchResults = results;
        yield SearchShowProfile(_searchResults[_currentIndex]);
      }
    } catch (e) {
      print(e);
      print('SEARCH FAILED');
      yield SearchCompleteNoResults('No results found.');
    }
  }

  // TODO: paginate results
  Stream<SearchState> _mapSearchClearedToState() async* {
    final users = await _userRepository.getAllUsers();
    yield SearchUninitialized(users);
  }

  Stream<SearchState> _mapSearchInspectUserToState(User user) async* {
    yield SearchShowProfile(user);
  }
}
