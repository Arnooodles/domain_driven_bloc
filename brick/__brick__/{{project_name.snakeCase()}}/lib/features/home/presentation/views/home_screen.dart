import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/mock_data.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/app_scroll_controller.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_app_bar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/scroll_controller_provider.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/shimmer.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/cubit/post/post_cubit.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/empty_post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Post> _shimmerPosts = List<Post>.generate(8, (_) => MockData.post);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(actions: {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar.buildCommonAppBarActions(context)),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Constant.mobileBreakpoint),
        child: BlocProvider<PostCubit>(
          create: (BuildContext context) {
            final PostCubit cubit = getIt<PostCubit>();
            unawaited(cubit.getPosts());
            return cubit;
          },
          child: Builder(
            builder: (BuildContext context) => RefreshIndicator(
              onRefresh: () => context.read<PostCubit>().getPosts(forceRefresh: true),
              child: BlocBuilder<PostCubit, PostState>(
                builder: (BuildContext context, PostState state) => state.maybeWhen(
                  onSuccess: (List<Post> posts, bool hasMore) =>
                      posts.isNotEmpty ? _PostList(posts: posts, hasMore: hasMore) : const EmptyPost(),
                  loadingMore: (List<Post> posts) => _PostList(posts: posts, hasMore: true, isLoadingMore: true),
                  orElse: () => Shimmer(child: _PostList(posts: _shimmerPosts, hasMore: false)),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _PostList extends HookWidget {
  const _PostList({required this.posts, required this.hasMore, this.isLoadingMore = false});

  final List<Post> posts;
  final bool hasMore;
  final bool isLoadingMore;

  static const double _scrollThreshold = 200;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollControllerProvider.of(context, AppScrollController.home);

    useEffect(() {
      void onScroll() {
        if (scrollController.hasClients &&
            scrollController.position.pixels >= scrollController.position.maxScrollExtent - _scrollThreshold &&
            hasMore &&
            !isLoadingMore) {
          unawaited(context.read<PostCubit>().loadMorePosts());
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, <Object?>[scrollController, hasMore, isLoadingMore]);

    return ListView.separated(
      padding: Paddings.topMedium,
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      itemCount: posts.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (BuildContext context, int index) => Gap.small(),
      itemBuilder: (BuildContext context, int index) {
        if (index == posts.length) {
          return const Padding(
            padding: Paddings.verticalMedium,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return PostContainer(post: posts[index]);
      },
    );
  }
}
