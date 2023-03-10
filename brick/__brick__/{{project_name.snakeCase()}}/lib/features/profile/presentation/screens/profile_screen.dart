import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/text_styles.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/error_message_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/extensions.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/user.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/screens/error_screen.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_avatar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_button.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_info_text_field.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/profile/presentation/widgets/profile_loading.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state.failure != null && !state.isLoading) {
            return ErrorScreen(
              onRefresh: () => context.read<AuthBloc>().getUser(),
              errorMessage: ErrorMessageUtils.generate(context, state.failure),
            );
          } else if (state.user != null && !state.isLoading) {
            final User user = state.user!;

            return RefreshIndicator(
              onRefresh: () => context.read<AuthBloc>().getUser(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.xl),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: context
                            .read<AppCoreBloc>()
                            .getScrollController(AppScrollController.profile),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _ProfileName(user: user),
                            _ProfileDetails(user: user),
                          ],
                        ),
                      ),
                    ),
                    VSpace(Insets.lg),
                    {{#pascalCase}}{{project_name}}{{/pascalCase}}Button(
                      text: context.l10n.profile__button_text__logout,
                      isEnabled: !state.isLogout,
                      isExpanded: true,
                      buttonType: ButtonType.filled,
                      onPressed: () => context.read<AuthBloc>().logout(),
                      padding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: Insets.sm,
                      ),
                    ),
                    VSpace(Insets.lg),
                  ],
                ),
              ),
            );
          }

          return const ProfileLoading();
        },
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
          VSpace.sm,
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
            title: context.l10n.profile__label_text__email,
            description: user.email.getOrCrash(),
          ),
          VSpace.sm,
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
            title: context.l10n.profile__label_text__phone_number,
            description: user.contactNumber.getOrCrash(),
          ),
          VSpace.sm,
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
            title: context.l10n.profile__label_text__gender,
            description: user.gender.name.capitalize(),
          ),
          VSpace.sm,
          {{#pascalCase}}{{project_name}}{{/pascalCase}}InfoTextField(
            title: context.l10n.profile__label_text__birthday,
            description: user.birthday.defaultFormat(),
          ),
          VSpace.sm,
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
    final TextStyle nameStyle = AppTextStyle.headlineMedium.copyWith(
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
            padding: EdgeInsets.all(Insets.lg),
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
