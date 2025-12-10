import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_web_adapter/dio_web_adapter.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  AuthRepository(this._dio)
    : _authDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl)) {
    if (kIsWeb) {
      _dio.httpClientAdapter = BrowserHttpClientAdapter()
        ..withCredentials = true;
      _authDio.httpClientAdapter = BrowserHttpClientAdapter()
        ..withCredentials = true;
    }

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          if (_isAuthPath(options.path)) return handler.next(options);

          final token = _accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          final status = e.response?.statusCode;
          final req = e.requestOptions;

          final alreadyRetried = req.extra[_kRetriedKey] == true;
          final shouldAttemptRefresh =
              _shouldAttemptRefresh(status, req.path) && !alreadyRetried;

          if (!shouldAttemptRefresh) {
            return handler.next(e);
          }

          try {
            await _refreshTokensOnce();
            final resp = await _retry(req);
            return handler.resolve(resp);
          } catch (_) {
            // Refresh failed - clear access
            _accessToken = null;
            return handler.next(e);
          }
        },
      ),
    );
  }

  // ----- consts / pola -----
  static const String _loginPath = '/auth/signin';
  static const String _signupPath = '/auth/signup';
  static const String _refreshPath = '/auth/refresh';
  static const String _logoutPath = '/auth/logout';
  static const String _kRetriedKey = '__retried__';

  final Dio _dio;
  final Dio _authDio;

  String? _accessToken;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  Dio get dio => _dio;

  // ----- helpers -----
  static bool _isAuthPath(String path) {
    return path == _loginPath ||
        path == _signupPath ||
        path == _refreshPath ||
        path == _logoutPath;
  }

  static bool _shouldAttemptRefresh(int? status, String path) {
    // codes to refresh
    final isUnauthorized = status == 401 || status == 403 || status == 419;
    return isUnauthorized && !_isAuthPath(path);
  }

  Future<void> _refreshTokensOnce() async {
    if (_isRefreshing) {
      await (_refreshCompleter ?? Completer<void>()
            ..complete())
          .future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();
    try {
      final resp = await _authDio.post(_refreshPath);
      final data = resp.data as Map<String, dynamic>?;
      final newAccess = data?['accessToken'] as String?;
      if (newAccess != null) _accessToken = newAccess;
      _refreshCompleter!.complete();
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions req) {
    final headers = Map<String, dynamic>.from(req.headers)
      ..remove('Authorization');

    final token = _accessToken;
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final opts = Options(
      method: req.method,
      headers: headers,
      contentType: req.contentType,
      responseType: req.responseType,
      followRedirects: req.followRedirects,
      receiveTimeout: req.receiveTimeout,
      sendTimeout: req.sendTimeout,
      validateStatus: req.validateStatus,
      listFormat: req.listFormat,
      extra: Map<String, dynamic>.from(req.extra)..[_kRetriedKey] = true,
    );

    return _dio.request<dynamic>(
      req.path,
      data: req.data,
      queryParameters: req.queryParameters,
      options: opts,
      cancelToken: req.cancelToken,
      onReceiveProgress: req.onReceiveProgress,
      onSendProgress: req.onSendProgress,
    );
  }

  // ----- Public API -----

  Future<void> signIn(String email, String password) async {
    final resp = await _authDio.post(
      _loginPath,
      data: {'email': email, 'password': password},
    );
    final data = resp.data as Map<String, dynamic>;
    _accessToken = data['accessToken'] as String?;
  }

  Future<void> signUp(String email, String password) async {
    final resp = await _authDio.post(
      _signupPath,
      data: {'email': email, 'password': password},
    );
    final data = resp.data as Map<String, dynamic>;
    _accessToken = data['accessToken'] as String?;
  }

  Future<Map<String, dynamic>> me() async {
    final r = await _dio.get('/auth/me');
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<void> logout() async {
    await _authDio.post(_logoutPath);
    _accessToken = null;
  }

  bool get isAuthenticated => _accessToken != null;
}
