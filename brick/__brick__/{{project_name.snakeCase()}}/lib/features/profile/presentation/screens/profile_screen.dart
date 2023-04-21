import 'package:dartx/dartx.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/error_message_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/user.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_avatar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_button.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_info_text_field.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/profile/presentation/widgets/profile_loading.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);

    return RefreshIndicator(
      onRefresh: () => context.read<AuthBloc>().getUser(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: context.screenHeight -
              AppTheme.defaultNavBarHeight -
              AppTheme.defaultAppBarHeight -
              Insets.large,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) =>
                _onStateChangedListener(
              context,
              state,
              isDialogShowing,
            ),
            buildWhen: _buildWhen,
            builder: (BuildContext context, AuthState authState) =>
                authState.maybeMap(
              orElse: () => const ProfileLoading(),
              authenticated: (Authenticated state) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.xlarge),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _ProfileName(user: state.user),
                          _ProfileDetails(user: state.user),
                        ],
                      ),
                    ),
                    {{#pascalCase}}{{project_name}}{{/pascalCase}}Button(
                      text: context.l10n.profile__button_text__logout,
                      isExpanded: true,
                      buttonType: ButtonType.filled,
                      onPressed: () => context.read<AuthBloc>().logout(),
                      padding: EdgeInsets.zero,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: Insets.small,
                      ),
                    ),
                    const VSpace(Insets.large),
                  ],
                ),
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
    state.mapOrNull(
      failed: (AuthFailure state) async {
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
          VSpace.small(),
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
            title: context.l10n.profile__label_text__email,
            description: user.email.getOrCrash(),
          ),
          VSpace.small(),
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
            title: context.l10n.profile__label_text__phone_number,
            description: user.contactNumber.getOrCrash(),
          ),
          VSpace.small(),
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
            title: context.l10n.profile__label_text__gender,
            description: user.gender.name.capitalize(),
          ),
          VSpace.small(),
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
            title: context.l10n.profile__label_text__birthday,
            description: user.birthday.defaultFormat(),
          ),
          VSpace.small(),
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
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
        {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar(
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
