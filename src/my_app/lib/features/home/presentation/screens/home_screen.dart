import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/app/themes/spacing.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/app/utils/error_message_utils.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/features/home/domain/bloc/post/post_bloc.dart';
import 'package:very_good_core/features/home/domain/model/post.dart';
import 'package:very_good_core/features/home/presentation/widgets/empty_post.dart';
import 'package:very_good_core/features/home/presentation/widgets/post_container.dart';
import 'package:very_good_core/features/home/presentation/widgets/post_container_loading.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);

    return RefreshIndicator(
      onRefresh: () => context.read<PostBloc>().getPosts(),
      color: context.colorScheme.primary,
      backgroundColor: context.colorScheme.background,
      child: BlocConsumer<PostBloc, PostState>(
        listener: (BuildContext context, PostState state) =>
            _onStateChangeListener(context, state, isDialogShowing),
        builder: (BuildContext context, PostState state) => state.maybeMap(
          success: (PostSuccess state) => _HomeContent(posts: state.posts),
          orElse: PostContainerLoading.new,
        ),
      ),
    );
  }

  Future<void> _onStateChangeListener(
    BuildContext context,
    PostState state,
    ValueNotifier<bool> isDialogShowing,
  ) async {
    await state.mapOrNull(
      failed: (PostFailure state) async {
        isDialogShowing.value = true;

        await DialogUtils.showError(
          context,
          ErrorMessageUtils.generate(context, state.failure),
          position: FlashPosition.top,
        );
        isDialogShowing.value = false;
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.posts,
  });

  final List<Post> posts;
  @override
  Widget build(BuildContext context) => posts.isNotEmpty
      ? ListView.separated(
          controller: context
              .read<AppCoreBloc>()
              .getScrollController(AppScrollController.home),
          itemBuilder: (BuildContext context, int index) =>
              PostContainer(post: posts[index]),
          separatorBuilder: (BuildContext context, int index) =>
              const VSpace(Insets.small),
          itemCount: posts.length,
        )
      : const EmptyPost();
}
