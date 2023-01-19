import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:my_app/app/constants/constant.dart';
import 'package:my_app/app/themes/app_colors.dart';
import 'package:my_app/app/themes/spacing.dart';
import 'package:my_app/app/themes/text_styles.dart';
import 'package:my_app/core/domain/bloc/my_app/my_app_bloc.dart';
import 'package:my_app/core/domain/model/value_objects.dart';
import 'package:my_app/core/presentation/widgets/my_app_avatar.dart';

class MyAppAppBar extends HookWidget {
  const MyAppAppBar({
    super.key,
    this.avatar,
  });

  final Url? avatar;

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(
          Constant.appName,
          style: AppTextStyle.headline5.copyWith(color: AppColors.white),
        ),
        leading: GoRouter.of(context).canPop()
            ? BackButton(
                onPressed: () => GoRouter.of(context).canPop()
                    ? GoRouter.of(context).pop()
                    : null,
              )
            : null,
        actions: <Widget>[
          IconButton(
            onPressed: () => context
                .read<MyAppBloc>()
                .switchTheme(Theme.of(context).brightness),
            icon: Theme.of(context).brightness == Brightness.dark
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
          ),
          MyAppAvatar(
            size: 32,
            imageUrl: avatar?.getOrCrash(),
            padding: EdgeInsets.all(Insets.sm),
          ),
        ],
      );
}
