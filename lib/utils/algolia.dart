import 'package:algolia/algolia.dart';
import 'package:canteen_frontend/utils/cloud_functions.dart';
import 'package:canteen_frontend/utils/constants.dart';

class AlgoliaSearch {
  static Algolia _algolia;
  static AlgoliaSearch _instance;
  static String _indexName = algoliaIndexName;

  AlgoliaSearch._();

  static Future getInstance({reset: false}) async {
    if (_instance == null || reset) {
      var algoliaSearch = AlgoliaSearch._();
      algoliaSearch._init();
      _instance = algoliaSearch;
    }
    return _instance;
  }

  void _init() async {
    final credentials =
        await CloudFunctionManager.getQueryApiKey.call().then((result) {
      return result.data;
    }, onError: (error) {
      print('Error fetching Algolia API key: $error');
    });

    _algolia = Algolia.init(
      applicationId: credentials['application_id'],
      apiKey: credentials['api_key'],
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
        .index('users')
        .search(searchTerm)
        .setRestrictSearchableAttributes(
            ['learn_skill.name', 'learn_skill.description']);
    return query.getObjects();
  }
}
