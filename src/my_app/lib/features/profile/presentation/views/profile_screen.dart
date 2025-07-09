import 'package:dartx/dartx.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/constants/mock_data.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/extensions/datetime_ext.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/app/utils/error_message_utils.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';
import 'package:very_good_core/core/domain/entity/enum/button_type.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/core/domain/entity/user.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_app_bar.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_avatar.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_button.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_info_text_field.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  void _onStateChangedListener(BuildContext context, AuthState state, ValueNotifier<bool> isDialogShowing) {
    if (isDialogShowing.value) return;

    state.whenOrNull(
      onFailure: (Failure failure) {
        isDialogShowing.value = true;

        DialogUtils.showError(
          context,
          ErrorMessageUtils.generate(context, failure),
          position: FlashPosition.top,
        ).whenComplete(() => isDialogShowing.value = false);
      },
    );
  }

  bool _buildWhen(_, AuthState current) => current.maybeWhen(onFailure: (_) => false, orElse: () => true);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);

    return Scaffold(
      appBar: VeryGoodCoreAppBar(actions: VeryGoodCoreAppBar.buildCommonAppBarActions(context)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Constant.mobileBreakpoint),
          child: RefreshIndicator(
            onRefresh: () => context.read<AuthBloc>().getUser(),
            child: BlocSelector<AppCoreBloc, AppCoreState, Map<AppScrollController, ScrollController>>(
              selector: (AppCoreState state) => state.scrollControllers,
              builder: (BuildContext context, Map<AppScrollController, ScrollController> scrollControllers) =>
                  CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollControllers.isNotEmpty
                        ? scrollControllers[AppScrollController.profile]
                        : ScrollController(),
                    slivers: <Widget>[
                      SliverFillRemaining(
                        child: BlocConsumer<AuthBloc, AuthState>(
                          listener: (BuildContext context, AuthState state) =>
                              _onStateChangedListener(context, state, isDialogShowing),
                          buildWhen: _buildWhen,
                          builder: (BuildContext context, AuthState authState) => authState.maybeWhen(
                            authenticated: (User user) => _ProfileContent(user: user),
                            orElse: () => Skeletonizer(child: _ProfileContent(user: MockData.user)),
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
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

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
          buttonType: ButtonType.outlined,
          textStyle: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.error),
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
  const _ProfileDetails({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Gap.small(),
      VeryGoodCoreInfoTextField(title: context.i18n.profile.label.email, description: user.email.getValue()),
      Gap.small(),
      if (user.phone != null) ...<Widget>[
        VeryGoodCoreInfoTextField(title: context.i18n.profile.label.phone_number, description: user.phone!.getValue()),
        Gap.small(),
      ],
      Gap.small(),
      if (user.address != null && user.address!.fullAddress != null) ...<Widget>[
        VeryGoodCoreInfoTextField(title: context.i18n.profile.label.address, description: user.address!.fullAddress!),
        Gap.small(),
      ],
      VeryGoodCoreInfoTextField(title: context.i18n.profile.label.gender, description: user.gender.name.capitalize()),
      Gap.small(),
      if (user.birthDate != null && user.age != null) ...<Widget>[
        VeryGoodCoreInfoTextField(
          title: context.i18n.profile.label.birthDate,
          description: user.birthDate!.defaultFormat(),
        ),
        Gap.small(),
        VeryGoodCoreInfoTextField(title: context.i18n.profile.label.age, description: user.age.toString()),
      ],
    ],
  );
}

class _ProfileName extends StatelessWidget {
  const _ProfileName({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final TextStyle? nameStyle = context.textTheme.headlineMedium;

    return Row(
      children: <Widget>[
        VeryGoodCoreAvatar(size: 80, imageUrl: user.image?.getValue()),
        Expanded(
          child: Padding(
            padding: Paddings.allLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                VeryGoodCoreText(text: user.firstName.getValue(), style: nameStyle),
                VeryGoodCoreText(text: user.lastName.getValue(), style: nameStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
