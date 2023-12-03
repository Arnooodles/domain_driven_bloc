import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/route_name.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text_url.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/model/post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container_footer.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container_header.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.small),
        child: GestureDetector(
          onTap: () => launchPostDetails(context),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(Insets.xsmall),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PostContainerHeader(post: post),
                  if (post.urlOverriddenByDest != null)
                    Padding(
                      padding: const EdgeInsets.all(Insets.medium),
                      child: {{#pascalCase}}{{project_name}}{{/pascalCase}}TextUrl(
                        url: post.urlOverriddenByDest!,
                        onTap: () => launchUrl(
                          Uri.parse(
                            post.urlOverriddenByDest!.getOrCrash(),
                          ),
                        ),
                      ),
                    ),
                  if (post.selftext.getOrCrash().isNotNullOrBlank)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: Insets.xsmall),
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors:
                                Theme.of(context).brightness == Brightness.light
                                    ? <Color>[
                                        const Color(0xFFf0f4fa),
                                        const Color(0xFFf0f4fa).withOpacity(0),
                                      ]
                                    : <Color>[
                                        const Color(0xFF202429),
                                        const Color(0xFF202429).withOpacity(0),
                                      ],
                          ),
                        ),
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: IgnorePointer(
                          child: Markdown(
                            data: post.selftext.getOrCrash(),
                            styleSheet: MarkdownStyleSheet(
                              p: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.secondary,
                              ),
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        ),
                      ),
                    ),
                  PostContainerFooter(post: post),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> launchPostDetails(BuildContext context) async {
    if (kIsWeb) {
      await launchUrl(
        Uri.parse(post.permalink.getOrCrash()),
        webOnlyWindowName: '_blank',
      );
    } else {
      GoRouter.of(context).goNamed(
        RouteName.postDetails.name,
        pathParameters: <String, String>{'postId': post.uid.getOrCrash()},
        extra: post,
      );
    }
  }
}
