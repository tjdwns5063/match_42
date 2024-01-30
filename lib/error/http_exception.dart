import 'package:flutter/cupertino.dart';

class HttpException implements Exception {
  HttpException({required this.statusCode, required this.message});

  final int statusCode;
  final Map<String, dynamic>? message;

  @override
  String toString() {
    if (message == null) {
      return '알 수 없는 에러가 발생했습니다.';
    }
    return message!['message'] ?? '알 수 없는 에러';
  }
}
