import 'package:offline_first/feature/home/domain/entity/article.dart';

abstract class IHomeRemoteRepo {
  Future<List<Article>> getNews();
}
