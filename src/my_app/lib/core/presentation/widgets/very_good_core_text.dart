import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:styled_text/styled_text.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_colors.dart';
import 'package:very_good_core/app/utils/url_launcher_utils.dart';
import 'package:very_good_core/core/domain/entity/enum/text_type.dart';

class VeryGoodCoreText extends StatelessWidget {
  const VeryGoodCoreText({
    required this.text,
    this.style,
    this.textType = TextType.regular,
    super.key,
    this.overflow,
    this.textAlign,
    this.maxLines,
    this.textWidthBasis,
    this.styledTextIcon,
  });

  final String text;
  final TextStyle? style;
  final TextType textType;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final IconData? styledTextIcon;

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultTextStyle = DefaultTextStyle.of(context).style;
    return switch (textType) {
      TextType.regular => Text(
          text,
          style: style,
          overflow: overflow,
          maxLines: maxLines,
          textWidthBasis: textWidthBasis,
          textAlign: textAlign,
        ),
      TextType.styled => _StyledText(
          text: text,
          style: style ?? defaultTextStyle,
          overflow: overflow,
          maxLines: maxLines,
          textWidthBasis: textWidthBasis,
          textAlign: textAlign,
          styledTextIcon: styledTextIcon,
        ),
      TextType.markdown => _MarkdownText(
          text: text,
          style: style ?? defaultTextStyle,
        ),
      TextType.selectable => SelectableText(
          text,
          style: style,
          maxLines: maxLines,
          textWidthBasis: textWidthBasis,
          textAlign: textAlign,
        ),
    };
  }
}

class _StyledText extends StatelessWidget {
  const _StyledText({
    required this.text,
    required this.style,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textAlign,
    this.styledTextIcon,
  });

  final String text;
  final TextStyle style;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final IconData? styledTextIcon;

  @override
  Widget build(BuildContext context) => StyledText(
        text: text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        tags: <String, StyledTextTagBase>{
          'b': StyledTextTag(
            style: style.copyWith(
              fontWeight: FontWeight.bold,
              color: style.color,
            ),
          ),
          'blueText': StyledTextTag(
            style: style.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.defaultTextUrl,
            ),
          ),
          'link': StyledTextActionTag(
            style: style.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.defaultTextUrl,
              color: AppColors.defaultTextUrl,
            ),
            (_, Map<String?, String?> attributes) {
              if (attributes['href'] != null) {
                UrlLauncherUtils.openBrowser(attributes['href']!);
              }
            },
          ),
          if (styledTextIcon != null)
            'icon': StyledTextIconTag(
              styledTextIcon!,
              size: style.fontSize ?? context.textTheme.bodySmall?.fontSize,
              color: AppColors.defaultTextUrl,
            ),
        },
      );
}

class _MarkdownText extends StatelessWidget {
  const _MarkdownText({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Markdown(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: style,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      );
}
