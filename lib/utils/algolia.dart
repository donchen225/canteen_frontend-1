import 'package:algolia/algolia.dart';
import 'package:canteen_frontend/utils/cloud_functions.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/environment_variables.dart';

class AlgoliaSearch {
  static Algolia _algolia;
  static AlgoliaSearch _instance;
  static String _indexName = algoliaIndexName;

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
    final apiKey =
        await CloudFunctionManager.getQueryApiKey.call().then((result) {
      return result.data.toString();
    }, onError: (error) {
      print('ERROR GETTING API KEY: $error');
    });

    print('API KEY: $apiKey');

    _algolia = Algolia.init(
      applicationId: algoliaAppId,
      apiKey: apiKey,
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
