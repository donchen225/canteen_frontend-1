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
