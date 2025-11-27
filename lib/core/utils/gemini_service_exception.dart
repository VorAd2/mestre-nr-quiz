import 'package:mestre_nr/core/utils/gemini_service_error_type.dart';

class GeminiServiceException implements Exception {
  final GeminiServiceErrorType type;
  String? message;

  GeminiServiceException({required this.type, this.message});

  @override
  String toString() => "GeminiServiceException: $message";
}
