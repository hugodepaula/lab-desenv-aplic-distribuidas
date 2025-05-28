import 'package:isar/isar.dart';

import 'package:offline_first/feature/home/domain/entity/article.dart';

part 'article_local_model.g.dart';

@collection
class ArticleLocalModel {
  Id? id;
  String? title;
  String? author;
  String? description;
  String? content;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? source;
}

extension ArticleModelX on ArticleLocalModel {
  Article get toEntity {
    return Article(
      sourceVal: source,
      authorVal: author,
      contentVal: content,
      descriptionVal: description,
      publishedAtVal: publishedAt,
      titleVal: title,
      urlToImageVal: urlToImage,
      urlVal: url,
    );
  }

  ArticleLocalModel fromEntity(Article article) {
    return ArticleLocalModel()
      ..source = article.sourceVal
      ..author = article.authorVal
      ..content = article.contentVal
      ..description = article.descriptionVal
      ..publishedAt = article.publishedAtVal
      ..title = article.titleVal
      ..urlToImage = article.urlToImageVal
      ..url = article.urlVal;
  }
}
