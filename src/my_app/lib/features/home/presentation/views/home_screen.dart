import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/constants/mock_data.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/themes/app_theme.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';
import 'package:very_good_core/features/home/domain/bloc/post/post_bloc.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';
import 'package:very_good_core/features/home/presentation/widgets/empty_post.dart';
import 'package:very_good_core/features/home/presentation/widgets/post_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Post> _generateFakePostData() => List<Post>.generate(8, (_) => MockData.post);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: VeryGoodCoreAppBar(actions: VeryGoodCoreAppBar.buildCommonAppBarActions(context)),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Constant.mobileBreakpoint),
        child: BlocProvider<PostBloc>(
          create: (BuildContext context) => getIt<PostBloc>()..getPosts(),
          child: Builder(
            builder: (BuildContext context) => RefreshIndicator(
              onRefresh: () => context.read<PostBloc>().getPosts(),
              child: BlocBuilder<PostBloc, PostState>(
                builder: (BuildContext context, PostState state) => state.maybeWhen(
                  onSuccess: (List<Post> posts) => posts.isNotEmpty ? _PostList(posts: posts) : const EmptyPost(),
                  orElse: () => Skeletonizer(
                    ignorePointers: false,
                    textBoneBorderRadius: const TextBoneBorderRadius(AppTheme.defaultBorderRadius),
                    justifyMultiLineText: true,
                    child: _PostList(posts: _generateFakePostData()),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _PostList extends StatelessWidget {
  const _PostList({required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) =>
      BlocSelector<AppCoreBloc, AppCoreState, Map<AppScrollController, ScrollController>>(
        selector: (AppCoreState state) => state.scrollControllers,
        builder: (BuildContext context, Map<AppScrollController, ScrollController> scrollController) =>
            ListView.separated(
              padding: Paddings.topMedium,
              controller: scrollController.isNotEmpty ? scrollController[AppScrollController.home] : ScrollController(),
              physics: const ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => PostContainer(post: posts[index]),
              separatorBuilder: (BuildContext context, int index) => Gap.small(),
              itemCount: posts.length,
            ),
      );
}
