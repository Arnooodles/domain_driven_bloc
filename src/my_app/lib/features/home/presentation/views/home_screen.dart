import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/constants/mock_data.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';
import 'package:very_good_core/core/presentation/widgets/wrappers/scroll_controller_provider.dart';
import 'package:very_good_core/core/presentation/widgets/wrappers/shimmer.dart';
import 'package:very_good_core/features/home/domain/cubit/post/post_cubit.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';
import 'package:very_good_core/features/home/presentation/widgets/empty_post.dart';
import 'package:very_good_core/features/home/presentation/widgets/post_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Post> _shimmerPosts = List<Post>.generate(8, (_) => MockData.post);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: VeryGoodCoreAppBar(actions: VeryGoodCoreAppBar.buildCommonAppBarActions(context)),
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

class _PostList extends StatefulWidget {
  const _PostList({required this.posts, required this.hasMore, this.isLoadingMore = false});

  final List<Post> posts;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  State<_PostList> createState() => _PostListState();
}

class _PostListState extends State<_PostList> {
  late ScrollController _scrollController;
  bool _listenerAttached = false;

  @override
  void dispose() {
    if (_listenerAttached) {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        widget.hasMore &&
        !widget.isLoadingMore) {
      unawaited(context.read<PostCubit>().loadMorePosts());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ScrollController newController = ScrollControllerProvider.of(context, AppScrollController.home);
    if (_listenerAttached) {
      _scrollController.removeListener(_onScroll);
    }
    _scrollController = newController;
    _scrollController.addListener(_onScroll);
    _listenerAttached = true;
  }

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: Paddings.topMedium,
    controller: _scrollController,
    physics: const ClampingScrollPhysics(),
    itemCount: widget.posts.length + (widget.isLoadingMore ? 1 : 0),
    separatorBuilder: (BuildContext context, int index) => Gap.small(),
    itemBuilder: (BuildContext context, int index) {
      if (index == widget.posts.length) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return PostContainer(post: widget.posts[index]);
    },
  );
}
