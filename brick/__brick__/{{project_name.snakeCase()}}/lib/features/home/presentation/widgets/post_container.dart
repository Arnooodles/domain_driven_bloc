import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/routes/route_name.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/url_launcher_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/text_type.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container_footer.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container_header.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({required this.post, super.key});

  final Post post;

  String _generateStyledLinkText(String url) => '<link href="$url">$url</link>';

  @override
  Widget build(BuildContext context) => Padding(
        padding: Paddings.horizontalSmall,
        child: GestureDetector(
          onTap: () => launchPostDetails(context),
          child: Card(
            color: context.colorScheme.surfaceBright,
            child: Padding(
              padding: Paddings.allXSmall,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PostContainerHeader(post: post),
                  if (post.urlOverriddenByDest != null)
                    Padding(
                      padding: Paddings.allMedium,
                      child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
                        textType: TextType.styled,
                        text: _generateStyledLinkText(
                          post.urlOverriddenByDest!.getOrCrash(),
                        ),
                      ),
                    ),
                  if (post.selftext.getOrCrash().isNotNullOrBlank)
                    Flexible(
                      child: Container(
                        padding: Paddings.bottomXSmall,
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: IgnorePointer(
                          child: Markdown(
                            data: post.selftext.getOrCrash(),
                            styleSheet: MarkdownStyleSheet(
                              p: context.textTheme.bodyMedium,
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
      await UrlLauncherUtils.launch(
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
