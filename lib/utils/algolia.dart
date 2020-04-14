import 'package:algolia/algolia.dart';
import 'package:canteen_frontend/utils/constants.dart';

class AlgoliaSearch {
  static Algolia _algolia;
  static AlgoliaSearch _instance;
  static String _indexName;

  AlgoliaSearch._();

  static Future getInstance() async {
    if (_instance == null) {
      var algoliaSearch = AlgoliaSearch._();
      algoliaSearch._init();
      _instance = algoliaSearch;
      _indexName = algoliaIndexName;
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
    AlgoliaQuery query = _algolia.instance.index(_indexName).search(searchTerm);
    return query.getObjects();
  }

  static Future<AlgoliaQuerySnapshot> queryTeachSkill(String searchTerm) async {
    AlgoliaQuery query = _algolia.instance
        .index(_indexName)
        .search(searchTerm)
        .setRestrictSearchableAttributes(
            ['teach_skill.name', 'teach_skill.description']);
    return query.getObjects();
  }

  static Future<AlgoliaQuerySnapshot> queryLearnSkill(String searchTerm) async {
    AlgoliaQuery query = _algolia.instance
        .index('users_dev')
        .search(searchTerm)
        .setRestrictSearchableAttributes(
            ['learn_skill.name', 'learn_skill.description']);
    return query.getObjects();
  }
}
