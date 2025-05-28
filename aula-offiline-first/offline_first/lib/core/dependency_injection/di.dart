import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'package:offline_first/core/services/local_db_service/i_local_db_service.dart';
import 'package:offline_first/core/services/local_db_service/local_db_service.dart';
import 'package:offline_first/core/services/navigation_service/i_navigation_service.dart';
import 'package:offline_first/core/services/navigation_service/navigation_service.dart';
import 'package:offline_first/core/services/network_service/i_network_service.dart';
import 'package:offline_first/core/services/network_service/network_service.dart';
import 'package:offline_first/feature/home/data/model/local/article_local_model.dart';
import 'package:offline_first/feature/home/data/repo/local/home_local_repo.dart';
import 'package:offline_first/feature/home/data/repo/remote/home_remote_repo.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_local_repo.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_remote_repo.dart';
import 'package:offline_first/feature/home/domain/usecase/get_news_from_local_db_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/get_news_from_network_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/local_db_data_flow_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/remove_old_news_from_local_db_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/save_news_to_local_db_usecase.dart';
import 'package:offline_first/feature/home/domain/usecase/watch_news_from_local_db_usecase.dart';
import 'package:offline_first/feature/home/presentation/provider/cubit/news_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  sl
    // third-party
    ..registerLazySingleton<Dio>(Dio.new)
    ..registerSingletonAsync<Isar>(() async => _isarInit())

    // services
    ..registerLazySingleton<INavigationService>(NavigationService.new)
    ..registerFactory<ILocalDBService>(() => LocalDBService(sl()))
    ..registerLazySingleton<INetworkService>(() => NetworkService(sl()))
    ..registerLazySingleton<Logger>(
      () => Logger(printer: PrettyPrinter(methodCount: 0)),
    )

    // repos
    ..registerLazySingleton<IHomeLocalRepo>(() => HomeLocalRepo(sl()))
    ..registerLazySingleton<IHomeRemoteRepo>(() => HomeRemoteRepo(sl()))

    // usecases
    ..registerLazySingleton<GetNewsFromNetworkUsecase>(
      () => GetNewsFromNetworkUsecase(sl()),
    )
    ..registerLazySingleton<GetNewsFromLocalDBUsecase>(
      () => GetNewsFromLocalDBUsecase(sl()),
    )
    ..registerLazySingleton<SaveNewsToLocalDBUsecase>(
      () => SaveNewsToLocalDBUsecase(sl()),
    )
    ..registerLazySingleton<WatchNewsFromLocalDBUsecase>(
      () => WatchNewsFromLocalDBUsecase(sl()),
    )
    ..registerLazySingleton<RemoveOldNewsFromLocalDbUseCase>(
      () => RemoveOldNewsFromLocalDbUseCase(sl()),
    )
    ..registerLazySingleton<LocalDbDataFlowUseCase>(
      () => LocalDbDataFlowUseCase(sl(), sl(), sl(), sl()),
    )

    // blocs
    ..registerLazySingleton<NewsCubit>(() => NewsCubit(sl(), sl(), sl()));
}

Future<Isar> _isarInit() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ArticleLocalModelSchema],
    directory: dir.path,
  );
  return isar;
}
