import 'package:dio/dio.dart';

import 'package:offline_first/core/enums/request_methods.dart';
import 'package:offline_first/core/services/network_service/i_network_service.dart';

class NetworkService implements INetworkService {
  const NetworkService(this._dio);

  final Dio _dio;

  @override
  Future<dynamic> networkRequest(
    String url, {
    required RequestMethods method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    Response<dynamic> response;
    switch (method) {
      case RequestMethods.get:
        response = await _dio.get(
          url,
          options: Options(
            headers: headers,
          ),
        );
    }

    switch (response.statusCode) {
      case 200:
        return response.data;
      default:
        throw Exception('Failed to load data');
    }
  }
}
