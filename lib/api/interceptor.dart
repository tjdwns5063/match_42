import 'package:dio/dio.dart';
import 'package:match_42/api/token_apis.dart';

import '../logger.dart';

class CustomInterceptor extends Interceptor {
  final TokenApis _tokenApis;

  CustomInterceptor(this._tokenApis);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
    options.headers.addEntries([
      MapEntry('Authorization', 'Bearer ${_tokenApis.read()}'),
    ]);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.logger.d(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    Log.logger.d(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
