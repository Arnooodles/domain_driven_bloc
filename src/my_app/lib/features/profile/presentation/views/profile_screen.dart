import 'package:dartx/dartx.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/constants/route_name.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/extensions/datetime_ext.dart';
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
import 'package:very_good_core/core/presentation/widgets/very_good_core_button.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_info_text_field.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:very_good_core/features/profile/presentation/widgets/profile_loading.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);
    final Color iconColor = context.colorScheme.onSecondaryContainer;

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppTheme.defaultAppBarHeight),
        child: VeryGoodCoreAppBar(
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
              builder: (BuildContext context, AuthState state) =>
                  state.maybeWhen(
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
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Constant.mobileBreakpoint,
          ),
          child: RefreshIndicator(
            onRefresh: () => context.read<AuthBloc>().getUser(),
            child: BlocSelector<AppCoreBloc, AppCoreState,
                Map<AppScrollController, ScrollController>>(
              selector: (AppCoreState state) => state.scrollControllers,
              builder: (
                BuildContext context,
                Map<AppScrollController, ScrollController> scrollControllers,
              ) =>
                  CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollControllers.isNotEmpty
                    ? scrollControllers[AppScrollController.profile]
                    : ScrollController(),
                slivers: <Widget>[
                  SliverFillRemaining(
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (BuildContext context, AuthState state) =>
                          _onStateChangedListener(
                        context,
                        state,
                        isDialogShowing,
                      ),
                      buildWhen: _buildWhen,
                      builder: (BuildContext context, AuthState authState) =>
                          authState.maybeWhen(
                        orElse: () => const ProfileLoading(),
                        authenticated: (User user) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Insets.xlarge,
                          ),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _ProfileName(user: user),
                                    _ProfileDetails(user: user),
                                  ],
                                ),
                              ),
                              VeryGoodCoreButton(
                                text: context.l10n.profile__button_text__logout,
                                isExpanded: true,
                                buttonType: ButtonType.filled,
                                onPressed: () =>
                                    context.read<AuthBloc>().logout(),
                                padding: EdgeInsets.zero,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: Insets.small,
                                ),
                              ),
                              const Gap(Insets.large),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onStateChangedListener(
    BuildContext context,
    AuthState state,
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

  bool _buildWhen(_, AuthState current) => current.maybeMap(
        orElse: () => true,
        failed: (_) => false,
      );
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.l10n.profile__label_text__email,
            description: user.email.getOrCrash(),
          ),
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.l10n.profile__label_text__phone_number,
            description: user.contactNumber.getOrCrash(),
          ),
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.l10n.profile__label_text__gender,
            description: user.gender.name.capitalize(),
          ),
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.l10n.profile__label_text__birthday,
            description: user.birthday.defaultFormat(),
          ),
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.l10n.profile__label_text__age,
            description: user.age,
          ),
        ],
      );
}

class _ProfileName extends StatelessWidget {
  const _ProfileName({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final TextStyle? nameStyle = context.textTheme.headlineMedium?.copyWith(
      color: context.colorScheme.onSecondaryContainer,
    );

    return Row(
      children: <Widget>[
        VeryGoodCoreAvatar(
          size: 80,
          imageUrl: user.avatar?.getOrCrash(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Insets.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.firstName.getOrCrash(),
                  style: nameStyle,
                ),
                Text(
                  user.lastName.getOrCrash(),
                  style: nameStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
