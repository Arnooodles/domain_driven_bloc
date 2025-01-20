import 'package:dartx/dartx.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/constants/mock_data.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/extensions/datetime_ext.dart';
import 'package:very_good_core/app/routes/route_name.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/app/utils/error_message_utils.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/bloc/theme/theme_bloc.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';
import 'package:very_good_core/core/domain/entity/enum/button_type.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_avatar.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_button.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_icon.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_info_text_field.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: VeryGoodCoreAppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () => context
                .read<ThemeBloc>()
                .switchTheme(Theme.of(context).brightness),
            icon: Theme.of(context).brightness == Brightness.dark
                ? VeryGoodCoreIcon(icon: right(Icons.light_mode))
                : VeryGoodCoreIcon(icon: right(Icons.dark_mode)),
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
          child: RefreshIndicator(
            backgroundColor: context.colorScheme.surface,
            color: context.colorScheme.primary,
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
                        orElse: () => Skeletonizer(
                          child: _ProfileContent(user: MockData.user),
                        ),
                        authenticated: (User user) =>
                            _ProfileContent(user: user),
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

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) => Padding(
        padding: Paddings.horizontalXLarge,
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
              text: context.i18n.profile.button.logout,
              isExpanded: true,
              buttonType: ButtonType.filled,
              onPressed: () => context.read<AuthBloc>().logout(),
              padding: EdgeInsets.zero,
              contentPadding: Paddings.verticalSmall,
            ),
            Gap.large(),
          ],
        ),
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
            title: context.i18n.profile.label.email,
            description: user.email.getOrCrash(),
            titleColor: context.colorScheme.primary,
          ),
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.i18n.profile.label.phone_number,
            description: user.contactNumber.getOrCrash(),
            titleColor: context.colorScheme.primary,
          ),
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.i18n.profile.label.gender,
            description: user.gender.name.capitalize(),
            titleColor: context.colorScheme.primary,
          ),
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.i18n.profile.label.birthday,
            description: user.birthday.defaultFormat(),
            titleColor: context.colorScheme.primary,
          ),
          Gap.small(),
          VeryGoodCoreInfoTextField(
            title: context.i18n.profile.label.age,
            description: user.age,
            titleColor: context.colorScheme.primary,
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
    final TextStyle? nameStyle = context.textTheme.headlineMedium;

    return Row(
      children: <Widget>[
        VeryGoodCoreAvatar(
          size: 80,
          imageUrl: user.avatar?.getOrCrash(),
        ),
        Expanded(
          child: Padding(
            padding: Paddings.allLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                VeryGoodCoreText(
                  text: user.firstName.getOrCrash(),
                  style: nameStyle,
                ),
                VeryGoodCoreText(
                  text: user.lastName.getOrCrash(),
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
