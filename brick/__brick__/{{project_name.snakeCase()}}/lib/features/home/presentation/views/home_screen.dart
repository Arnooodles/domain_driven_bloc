import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/mock_data.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/routes/route_name.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/error_message_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/theme/theme_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/app_scroll_controller.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/user.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_app_bar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_avatar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/empty_post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () => context
                  .read<ThemeBloc>()
                  .switchTheme(Theme.of(context).brightness),
              icon: Theme.of(context).brightness == Brightness.dark
                  ? {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.light_mode))
                  : {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.dark_mode)),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, AuthState state) =>
                  state.maybeWhen(
                orElse: SizedBox.shrink,
                authenticated: (User user) => GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).goNamed(RouteName.profile.name),
                  child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar(
                    size: 32,
                    imageUrl: user.avatar?.getOrCrash(),
                    padding: Paddings.allSmall,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Constant.mobileBreakpoint,
            ),
            child: _HomeContent(),
          ),
        ),
      );
}

class _HomeContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);

    return BlocProvider<PostBloc>(
      create: (BuildContext context) => getIt<PostBloc>()..getPosts(),
      child: Builder(
        builder: (BuildContext context) => RefreshIndicator(
          backgroundColor: context.colorScheme.surface,
          color: context.colorScheme.primary,
          onRefresh: () => context.read<PostBloc>().getPosts(),
          child: BlocConsumer<PostBloc, PostState>(
            listener: (BuildContext context, PostState state) =>
                _onStateChangeListener(context, state, isDialogShowing),
            builder: (BuildContext context, PostState state) => state.maybeWhen(
              success: (List<Post> posts) => posts.isNotEmpty
                  ? _PostList(posts: posts)
                  : const EmptyPost(),
              orElse: () => Skeletonizer(
                textBoneBorderRadius:
                    TextBoneBorderRadius(AppTheme.defaultBoardRadius),
                justifyMultiLineText: true,
                child: _PostList(
                  posts: _generateFakePostData(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Post> _generateFakePostData() => List<Post>.generate(
        8,
        (_) => MockData.post,
      );

  void _onStateChangeListener(
    BuildContext context,
    PostState state,
    ValueNotifier<bool> isDialogShowing,
  ) {
    state.whenOrNull(
      failed: (Failure failure) async {
        isDialogShowing.value = true;

        await DialogUtils.showError(
          context,
          ErrorMessageUtils.generate(context, failure),
          position: FlashPosition.top,
        );
        isDialogShowing.value = false;
      },
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList({
    required this.posts,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) => BlocSelector<AppCoreBloc, AppCoreState,
          Map<AppScrollController, ScrollController>>(
        selector: (AppCoreState state) => state.scrollControllers,
        builder: (
          BuildContext context,
          Map<AppScrollController, ScrollController> scrollController,
        ) =>
            ListView.separated(
          padding: Paddings.topMedium,
          controller: scrollController.isNotEmpty
              ? scrollController[AppScrollController.home]
              : ScrollController(),
          itemBuilder: (BuildContext context, int index) => PostContainer(
            post: posts[index],
          ),
          separatorBuilder: (BuildContext context, int index) => Gap.small(),
          itemCount: posts.length,
        ),
      );
}
