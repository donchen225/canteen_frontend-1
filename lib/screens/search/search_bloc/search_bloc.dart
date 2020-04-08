import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserRepository _userRepository;

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
      yield* _mapSearchStartedToState(event.identifier);
    } else if (event is SearchCleared) {
      yield* _mapSearchClearedToState();
    } else if (event is SearchInspectUser) {
      yield* _mapSearchInspectUserToState(event.user);
    }
  }

  Stream<SearchState> _mapSearchStartedToState(String identifier) async* {
    yield SearchLoading();
    try {
      yield SearchCompleteWithResults(await _userRepository.getAllUsers());
      // final user = (_userBloc.state as UserLoaded).user;
      // if ([user.email, user.displayName].contains(identifier)) {
      //   yield SearchCompleteNoResults("Can't send invite to self");
      // } else {
      //   final searchResults = await _userRepository.searchUser(identifier);
      //   if (searchResults.isNotEmpty) {
      //     yield SearchCompleteWithResults(searchResults);
      //   } else {
      //     yield SearchCompleteNoResults('User not found');
      //   }
      // }
    } catch (e) {
      print(e);
      print('SEARCH FAILED');
      yield SearchCompleteNoResults('User not found');
    }
  }

  // TODO: paginate results
  Stream<SearchState> _mapSearchClearedToState() async* {
    final users = await _userRepository.getAllUsers();
    yield SearchEmpty(users);
  }

  Stream<SearchState> _mapSearchInspectUserToState(User user) async* {
    yield SearchShowProfile(user);
  }
}
