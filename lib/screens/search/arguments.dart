import 'package:canteen_frontend/models/group/group.dart';

class SearchArguments {
  final String initialQuery;
  final List<String> searchHistory;

  SearchArguments({this.initialQuery = '', this.searchHistory = const []});
}

class SearchResultsArguments {
  final String query;

  SearchResultsArguments({
    this.query,
  });
}

class GroupArguments {
  final Group group;

  GroupArguments({
    this.group,
  });
}
