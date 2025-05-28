import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/web.dart';

import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/core/usecase/i_usecase.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/home/domain/usecase/get_news_from_local_db_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/local_db_data_flow_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/watch_news_from_local_db_usecase.dart';

part 'news_state.dart';
part 'news_cubit.freezed.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit(
    this._watchNewsFromLocalDBUsecase,
    this._getNewsFromLocalDBUsecase,
    this._localDbDataFlowUseCase,
  ) : super(const NewsState.loading());

  final WatchNewsFromLocalDBUsecase _watchNewsFromLocalDBUsecase;
  final LocalDbDataFlowUseCase _localDbDataFlowUseCase;
  final GetNewsFromLocalDBUsecase _getNewsFromLocalDBUsecase;

  Future<void> newsFlow() async {
    await getNewsFromLocalDB();
    initWatchLocalData();
    await localDbFlow();
  }

  Future<void> getNewsFromLocalDB() async {
    try {
      final news = await _getNewsFromLocalDBUsecase.call(const NoParams());
      emit(NewsState.loaded(news));
    } catch (e) {
      emit(NewsState.error(e.toString()));
    }
  }

  Future<void> localDbFlow() async {
    try {
      await _localDbDataFlowUseCase.call(const NoParams());
    } catch (e) {
      final data = state.maybeMap(
        orElse: () => <Article>[],
        loaded: (value) => value.articles,
      );
      emit(const NewsState.localDbError());
      emit(NewsState.loaded(data));
    }
  }

  void initWatchLocalData() => _watchNewsFromLocalDBUsecase.call(emitLocalData);

  void emitLocalData(List<Article> data) {
    sl<Logger>().i('Getting data from stream...');
    emit(NewsState.loaded(data));
  }
}
