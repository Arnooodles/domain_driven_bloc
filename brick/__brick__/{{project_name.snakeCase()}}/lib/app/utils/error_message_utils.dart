import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';

// ignore_for_file: avoid_dynamic_calls
final class ErrorMessageUtils {
  static String generate(BuildContext context, dynamic error) {
    if (error is String) {
      return error;
    } else if (error is Failure) {
      if (error is ServerError) {
        return _parseMessage(context, error);
      } else if (error is UnexpectedError) {
        return error.error ?? context.i18n.common.error.unexpected_error;
      } else if (error is EmptyString) {
        return context.i18n.common.error
            .empty_string(property: error.property.toString());
      } else if (error is InvalidEmailFormat) {
        return context.i18n.common.error.email_format;
      } else if (error is ExceedingCharacterLength) {
        return error.max != null
            ? context.i18n.common.error.max_characters
            : context.i18n.common.error.min_characters;
      } else {
        return errorString(error);
      }
    } else {
      return errorString(error);
    }
  }

  static String errorString(dynamic error) {
    final String errorString = error.toString();

    return errorString != 'null' ? errorString : '';
  }

  static String _parseMessage(BuildContext context, dynamic error) {
    try {
      final Map<String, dynamic> object =
          jsonDecode(error.error?.toString() ?? '{}') as Map<String, dynamic>;
      final String errorCode = error.code.value.toString();
      return switch (object) {
        {'message': final String message} => context.i18n.common.error
            .server_error(code: errorCode, error: message),
        {'error': final String errorMessage} =>
          context.i18n.common.error.server_error(
            code: errorCode,
            error: errorMessage,
          ),
        _ => context.i18n.common.error.server_error(
            code: errorCode,
            error: error.error.toString(),
          )
      };
    } on Exception catch (error) {
      return error.toString();
    }
  }
}
