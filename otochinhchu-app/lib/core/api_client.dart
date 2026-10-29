/// API client dùng chung (dio) — tự gắn Bearer token, xử lý response {code, data, timestamp}.
library;

import 'package:dio/dio.dart';
import 'session.dart';

class ApiClient {
  static late Dio _dio;
  static String baseUrl = 'http://10.0.2.2:3000/api/v1';

  static void init({required String baseUrl}) {
    ApiClient.baseUrl = baseUrl;
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final t = Session.token;
          if (t != null && t.isNotEmpty)
            options.headers['Authorization'] = 'Bearer $t';
          handler.next(options);
        },
      ),
    );
  }

  /// Trả về `data` bên trong envelope {code, data, timestamp}.
  static Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final res = await _dio.get(path, queryParameters: query);
    return res.data is Map && res.data['data'] != null
        ? res.data['data']
        : res.data;
  }

  static Future<dynamic> post(String path, {Object? body}) async {
    final res = await _dio.post(path, data: body);
    return res.data is Map && res.data['data'] != null
        ? res.data['data']
        : res.data;
  }

  static Future<dynamic> patch(String path, {Object? body}) async {
    final res = await _dio.patch(path, data: body);
    return res.data is Map && res.data['data'] != null
        ? res.data['data']
        : res.data;
  }

  static Future<dynamic> delete(String path) async {
    final res = await _dio.delete(path);
    return res.data is Map && res.data['data'] != null
        ? res.data['data']
        : res.data;
  }

  /// Trả message lỗi dễ đọc từ DioException.
  static String errMsg(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null)
        return data['message'].toString();
      return 'Lỗi kết nối (${e.response?.statusCode ?? 'mạng'})';
    }
    return e.toString();
  }
}
