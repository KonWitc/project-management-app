import 'package:dio/dio.dart';
import 'package:dio_web_adapter/dio_web_adapter.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE',
        defaultValue: 'http://localhost:3000',
      ),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.httpClientAdapter = BrowserHttpClientAdapter()..withCredentials = true;
  return dio;
}
