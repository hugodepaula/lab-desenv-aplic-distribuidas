import 'package:logger/logger.dart';

import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/core/usecase/i_usecase.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_local_repo.dart';

class SaveNewsToLocalDBUsecase implements Usecase<void, List<Article>> {
  const SaveNewsToLocalDBUsecase(this._homeLocalRepo);
  final IHomeLocalRepo _homeLocalRepo;

  @override
  Future<void> call(List<Article> list) async {
    sl<Logger>().i('Saving news to local db...');
    return _homeLocalRepo.saveLocalData(list);
  }
}
