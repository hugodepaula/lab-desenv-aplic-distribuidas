import 'package:offline_first/core/enums/request_methods.dart';

abstract class INetworkService {
  Future<dynamic> networkRequest(
    String url, {
    required RequestMethods method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  });
}
