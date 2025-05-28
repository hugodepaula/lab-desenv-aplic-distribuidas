import 'package:logger/logger.dart';

import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/core/usecase/i_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/get_news_from_local_db_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/get_news_from_network_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/remove_old_news_from_local_db_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/save_news_to_local_db_usecase.dart';

class LocalDbDataFlowUseCase implements Usecase<void, NoParams> {
  const LocalDbDataFlowUseCase(
    this._getNewsFromNetworkUsecase,
    this._saveNewsToLocalDBUsecase,
    this._removeOldNewsFromLocalDbUseCase,
    this._getNewsFromLocalDBUsecase,
  );
  final GetNewsFromNetworkUsecase _getNewsFromNetworkUsecase;
  final SaveNewsToLocalDBUsecase _saveNewsToLocalDBUsecase;
  final RemoveOldNewsFromLocalDbUseCase _removeOldNewsFromLocalDbUseCase;
  final GetNewsFromLocalDBUsecase _getNewsFromLocalDBUsecase;

  @override
  Future<void> call(_) async {
    try {
      sl<Logger>().i('Started local db data flow...');
      final data = await _getNewsFromNetworkUsecase(const NoParams());
      final previousData = await _getNewsFromLocalDBUsecase(const NoParams());
      await _removeOldNewsFromLocalDbUseCase(const NoParams());
      try {
        await _saveNewsToLocalDBUsecase(data);
      } catch (e) {
        await _saveNewsToLocalDBUsecase(previousData);
      }
    } catch (_) {
      rethrow;
    }
  }
}
