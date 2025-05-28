import 'package:offline_first/core/enums/request_methods.dart';
import 'package:offline_first/core/services/network_service/i_network_service.dart';
import 'package:offline_first/feature/home/core/constants/home_network_constants.dart';
import 'package:offline_first/feature/home/data/model/remote/article_model.dart';
import 'package:offline_first/feature/home/data/model/remote/base_response.dart';
import 'package:offline_first/feature/home/domain/entity/article.dart';
import 'package:offline_first/feature/home/domain/repo/i_home_remote_repo.dart';

class HomeRemoteRepo implements IHomeRemoteRepo {
  const HomeRemoteRepo(this._networkService);
  final INetworkService _networkService;

  @override
  Future<List<Article>> getNews() async {
    try {
      final response = await _networkService.networkRequest(
        HomeNetworkConstants.homeUrl,
        method: RequestMethods.get,
        headers: HomeNetworkConstants.headers,
      );
      return (BaseResponse.fromJson(response as Map<String, dynamic>)
                  .articles ??
              <ArticleModel>[])
          .map((e) => e.toEntity)
          .toList();
    } catch (_) {
      rethrow;
    }
  }
}
