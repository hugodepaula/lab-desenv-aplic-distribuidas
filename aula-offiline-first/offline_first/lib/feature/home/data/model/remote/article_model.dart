import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:offline_first/feature/home/data/model/remote/source_model.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@Freezed(toJson: false)
class ArticleModel with _$ArticleModel {
  const factory ArticleModel({
    SourceModel? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}

extension ArticleModelX on ArticleModel {
  Article get toEntity {
    return Article(
      sourceVal: source?.name,
      authorVal: author,
      contentVal: content,
      descriptionVal: description,
      publishedAtVal: publishedAt,
      titleVal: title,
      urlToImageVal: urlToImage,
      urlVal: url,
    );
  }
}
