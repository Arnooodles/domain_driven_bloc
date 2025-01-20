import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';

class EmptyPost extends StatelessWidget {
  const EmptyPost({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Container(
              padding: Paddings.horizontalLarge,
              width: Insets.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(
                      icon: right(Icons.list_alt),
                      size: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: Insets.small,
                        bottom: Insets.xSmall,
                      ),
                      child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
                        text: context.i18n.post.label.empty_post,
                        style: context.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
