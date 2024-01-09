import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/constants/mock_data.dart';
import 'package:very_good_core/app/constants/route_name.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/injection.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/app/utils/error_message_utils.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/bloc/theme/theme_bloc.dart';
import 'package:very_good_core/core/domain/model/failure.dart';
import 'package:very_good_core/core/domain/model/user.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_avatar.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:very_good_core/features/home/domain/bloc/post/post_bloc.dart';
import 'package:very_good_core/features/home/domain/model/post.dart';
import 'package:very_good_core/features/home/presentation/widgets/empty_post.dart';
import 'package:very_good_core/features/home/presentation/widgets/post_container.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = context.colorScheme.onSecondaryContainer;

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: VeryGoodCoreAppBar(
        titleColor: context.colorScheme.primary,
        actions: <Widget>[
          IconButton(
            onPressed: () => context
                .read<ThemeBloc>()
                .switchTheme(Theme.of(context).brightness),
            icon: Theme.of(context).brightness == Brightness.dark
                ? Icon(Icons.light_mode, color: iconColor)
                : Icon(Icons.dark_mode, color: iconColor),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, AuthState state) => state.maybeWhen(
              orElse: SizedBox.shrink,
              authenticated: (User user) => GestureDetector(
                onTap: () =>
                    GoRouter.of(context).goNamed(RouteName.profile.name),
                child: VeryGoodCoreAvatar(
                  size: 32,
                  imageUrl: user.avatar?.getOrCrash(),
                  padding: const EdgeInsets.all(Insets.small),
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
}

class _HomeContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);

    return BlocProvider<PostBloc>(
      create: (BuildContext context) => getIt<PostBloc>()..getPosts(),
      child: Builder(
        builder: (BuildContext context) => RefreshIndicator(
          onRefresh: () => context.read<PostBloc>().getPosts(),
          color: context.colorScheme.primary,
          backgroundColor: context.colorScheme.background,
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
        4,
        (_) => MockData.post,
      );

  Future<void> _onStateChangeListener(
    BuildContext context,
    PostState state,
    ValueNotifier<bool> isDialogShowing,
  ) async {
    await state.whenOrNull(
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
          padding: const EdgeInsets.only(top: Insets.medium),
          controller: scrollController.isNotEmpty
              ? scrollController[AppScrollController.home]
              : ScrollController(),
          itemBuilder: (BuildContext context, int index) =>
              PostContainer(post: posts[index]),
          separatorBuilder: (BuildContext context, int index) =>
              const Gap(Insets.small),
          itemCount: posts.length,
        ),
      );
}
