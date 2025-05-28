part of 'news_cubit.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState.loading() = _Loading;
  const factory NewsState.loaded(List<Article> articles) = _Loaded;
  const factory NewsState.error(String? message) = _Error;
  const factory NewsState.localDbError() = _localDbError;
}
