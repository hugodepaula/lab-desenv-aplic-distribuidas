import 'package:freezed_annotation/freezed_annotation.dart';

part 'source_model.freezed.dart';
part 'source_model.g.dart';

@Freezed(toJson: false)
class SourceModel with _$SourceModel {
  const factory SourceModel({
    String? id,
    String? name,
  }) = _SourceModel;

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);
}
