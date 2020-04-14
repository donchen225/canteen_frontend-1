import 'package:algolia/algolia.dart';

class AlgoliaSearch {
  static Algolia _algolia;
  static AlgoliaSearch _instance;

  AlgoliaSearch._();

  static Future getInstance() async {
    if (_instance == null) {
      var algoliaSearch = AlgoliaSearch._();
      algoliaSearch._init();
      _instance = algoliaSearch;
    }
    return _instance;
  }

  void _init() async {
    _algolia = Algolia.init(
      applicationId: 'J79ENQAH4O',
      apiKey: '25645b314d505e52216aa9386e6927f7',
    );
  }

  static Future<AlgoliaQuerySnapshot> query(String searchTerm) async {
    AlgoliaQuery query = _algolia.instance.index('users').search(searchTerm);
    return query.getObjects();
  }
}
