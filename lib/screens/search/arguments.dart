import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/user/user.dart';

class SearchArguments {
  final String initialQuery;
  final List<String> searchHistory;
  final bool isInitialSearch;

  SearchArguments(
      {this.initialQuery = '',
      this.searchHistory = const [],
      this.isInitialSearch = true});
}

class SearchResultsArguments {
  final String query;
  final List<User> results;

  SearchResultsArguments({
    this.query,
    this.results,
  });
}

class GroupArguments {
  final Group group;

  GroupArguments({
    this.group,
  });
}
