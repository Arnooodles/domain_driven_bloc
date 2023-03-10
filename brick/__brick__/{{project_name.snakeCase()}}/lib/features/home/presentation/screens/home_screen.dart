import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/error_message_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/extensions.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/empty_post.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/widgets/post_container_loading.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);

    return BlocConsumer<PostBloc, PostState>(
      builder: (BuildContext context, PostState state) => state.isLoading
          ? const PostContainerLoading()
          : RefreshIndicator(
              onRefresh: () => context.read<PostBloc>().getPosts(),
              color: context.colorScheme.primary,
              backgroundColor: context.colorScheme.background,
              child: state.posts.isNotEmpty
                  ? ListView.separated(
                      controller: context
                          .read<AppCoreBloc>()
                          .getScrollController(AppScrollController.home),
                      itemBuilder: (BuildContext context, int index) =>
                          PostContainer(post: state.posts[index]),
                      separatorBuilder: (BuildContext context, int index) =>
                          VSpace(Insets.sm),
                      itemCount: state.posts.length,
                    )
                  : const EmptyPost(),
            ),
      listener: (BuildContext context, PostState state) =>
          _homeScreenListener(context, state, isDialogShowing),
    );
  }

  Future<void> _homeScreenListener(
    BuildContext context,
    PostState state,
    ValueNotifier<bool> isDialogShowing,
  ) async {
    if (state.failure != null && !isDialogShowing.value) {
      isDialogShowing.value = true;
      await DialogUtils.showToast(
        context,
        ErrorMessageUtils.generate(context, state.failure),
      );
      isDialogShowing.value = false;
    }
  }
}
