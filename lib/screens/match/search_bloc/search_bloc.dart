import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/search_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserRepository _userRepository;
  final UserBloc _userBloc;

  SearchBloc(
      {@required UserRepository userRepository, @required UserBloc userBloc})
      : assert(userRepository != null),
        assert(userBloc != null),
        _userRepository = userRepository,
        _userBloc = userBloc;
  @override
  SearchState get initialState => SearchReset();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchStarted) {
      yield* _mapSearchStartedToState(event.identifier);
    } else if (event is SearchCleared) {
      yield* _mapSearchClearedToState();
    }
  }

  Stream<SearchState> _mapSearchStartedToState(String identifier) async* {
    yield SearchLoading();
    try {
      final user = (_userBloc.state as UserLoaded).user;
      if ([user.email, user.displayName].contains(identifier)) {
        yield SearchCompleteNoResults("Can't send invite to self");
      } else {
        final searchResults = await _userRepository.searchUser(identifier);
        if (searchResults.isNotEmpty) {
          yield SearchCompleteWithResults(searchResults);
        } else {
          yield SearchCompleteNoResults('User not found');
        }
      }
    } catch (_) {
      print('SEARCH FAILED');
      yield SearchCompleteNoResults('User not found');
    }
  }

  Stream<SearchState> _mapSearchClearedToState() async* {
    yield SearchReset();
  }
}
