import 'package:mestre_nr/core/utils/error_type.dart';

class FetchResult {
  final Object? data;
  final ErrorType? error;

  FetchResult.success(this.data) : error = null;
  FetchResult.error(this.error) : data = null;

  bool get isSuccess => error == null;
}
