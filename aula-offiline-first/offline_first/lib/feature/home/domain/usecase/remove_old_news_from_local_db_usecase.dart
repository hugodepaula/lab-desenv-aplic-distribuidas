import 'package:logger/web.dart';

import 'package:offline_first/core/dependency_injection/di.dart';
import 'package:offline_first/core/usecase/i_usecase.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_local_repo.dart';

class RemoveOldNewsFromLocalDbUseCase implements Usecase<void, NoParams> {
  const RemoveOldNewsFromLocalDbUseCase(this._homeLocalRepo);
  final IHomeLocalRepo _homeLocalRepo;
  @override
  Future<void> call(_) async {
    try {
      sl<Logger>().i('Removing old news from local db...');
      await _homeLocalRepo.removeLocalData();
    } catch (e) {
      rethrow;
    }
  }
}
