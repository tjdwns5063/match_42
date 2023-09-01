import 'package:flutter/cupertino.dart';

class HttpException implements Exception {
  HttpException({required this.statusCode, required this.message});

  final int statusCode;
  final String? message;

  @override
  String toString() {
    return message ?? '알 수 없는 에러가 발생했습니다.';
  }
}
