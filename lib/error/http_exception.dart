import 'package:flutter/cupertino.dart';

class HttpException implements Exception {
  HttpException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() {
    return message;
  }
}
