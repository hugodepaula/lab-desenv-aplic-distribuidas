import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:offline_first/feature/home/data/model/remote/article_model.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';

@Freezed(toJson: false)
class BaseResponse with _$BaseResponse {
  const factory BaseResponse({
    String? status,
    int? totalResults,
    List<ArticleModel>? articles,
  }) = _BaseResponse;

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
}
