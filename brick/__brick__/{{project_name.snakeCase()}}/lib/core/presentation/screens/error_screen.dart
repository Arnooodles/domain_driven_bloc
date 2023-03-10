import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/text_styles.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/extensions.dart';

class ErrorScreen extends HookWidget {
  const ErrorScreen({
    super.key,
    required this.onRefresh,
    required this.errorMessage,
  });

  final Future<void> Function()? onRefresh;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) => onRefresh != null
      ? RefreshIndicator(
          onRefresh: onRefresh!,
          child: _ErrorContent(errorMessage: errorMessage),
        )
      : _ErrorContent(errorMessage: errorMessage);
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    required this.errorMessage,
  });

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.colorScheme.onSurface;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error, size: 50, color: context.colorScheme.error),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Text(
            context.l10n.common_generic_error,
            style: AppTextStyle.titleMedium.copyWith(color: textColor),
          ),
        ),
        if (kDebugMode && (errorMessage?.isNotNullOrBlank ?? false))
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Text(
              errorMessage!,
              style: AppTextStyle.titleSmall.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
