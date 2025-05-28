import 'package:logger/logger.dart';

import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/core/usecase/i_usecase.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_local_repo.dart';

class GetNewsFromLocalDBUsecase implements Usecase<List<Article>, NoParams> {
  const GetNewsFromLocalDBUsecase(this._homeLocalRepo);
  final IHomeLocalRepo _homeLocalRepo;

  @override
  Future<List<Article>> call(_) async {
    sl<Logger>().i('Getting values from LOCAL...');
    return _homeLocalRepo.getLocalData();
  }
}
