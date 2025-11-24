import 'package:mestre_nr/core/utils/generation_error_type.dart';

class FetchResult {
  final Object? data;
  final GenerationErrorType? error;

  FetchResult.success(this.data) : error = null;
  FetchResult.error(this.error) : data = null;

  bool get isSuccess => error == null;
}
