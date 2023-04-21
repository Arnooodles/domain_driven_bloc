import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/helpers/extensions.dart';
import 'package:very_good_core/app/helpers/injection.dart';
import 'package:very_good_core/app/themes/spacing.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/app/utils/error_message_utils.dart';
import 'package:very_good_core/core/presentation/widgets/app_title.dart';
import 'package:very_good_core/core/presentation/widgets/connectivity_checker.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_button.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text_field.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:very_good_core/features/auth/domain/bloc/login/login_bloc.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordTextController =
        useTextEditingController();
    final TextEditingController emailTextController =
        useTextEditingController();

    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => getIt<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: _onStateChangedListener,
        buildWhen: _buildWhen,
        builder: (BuildContext context, LoginState state) {
          emailTextController
            ..value = TextEditingValue(
              text: state.mapOrNull(
                    initial: (LoginInitial state) => state.emailAddress,
                  ) ??
                  '',
            )
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: emailTextController.text.length),
            );

          return WillPopScope(
            onWillPop: () => DialogUtils.showExitDialog(context),
            child: ConnectivityChecker.scaffold(
              backgroundColor: context.colorScheme.background,
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(Insets.xlarge),
                  constraints: const BoxConstraints(
                    maxWidth: Constant.mobileBreakpoint,
                  ),
                  child: Column(
                    children: <Widget>[
                      const Flexible(child: Center(child: AppTitle())),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            VeryGoodCoreTextField(
                              controller: emailTextController,
                              labelText: context.l10n.login__label_text__email,
                              hintText:
                                  context.l10n.login__text_field_hint__email,
                              onChanged: (String value) => context
                                  .read<LoginBloc>()
                                  .onEmailAddressChanged(value),
                              autofocus: true,
                            ),
                            VSpace.large(),
                            VeryGoodCoreTextField(
                              controller: passwordTextController,
                              labelText:
                                  context.l10n.login__label_text__password,
                              hintText:
                                  context.l10n.login__text_field_hint__password,
                              textInputType: TextInputType.visiblePassword,
                              isPassword: true,
                            ),
                            VSpace.xxxlarge(),
                            VeryGoodCoreButton(
                              text: context.l10n.login__button_text__login,
                              isEnabled: state.mapOrNull(
                                    initial: (LoginInitial state) =>
                                        !state.isLoading,
                                  ) ??
                                  true,
                              isExpanded: true,
                              buttonType: ButtonType.filled,
                              onPressed: () => context.read<LoginBloc>().login(
                                    emailTextController.text,
                                    passwordTextController.text,
                                  ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: Insets.small,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onStateChangedListener(BuildContext context, LoginState state) {
    state.mapOrNull(
      success: (LoginSuccess state) => context.read<AuthBloc>().authenticate(),
      failed: (LoginFailure state) => DialogUtils.showError(
        context,
        ErrorMessageUtils.generate(context, state.failure),
      ),
    );
  }

  bool _buildWhen(_, LoginState current) => current.maybeMap(
        orElse: () => true,
        success: (_) => false,
        failed: (_) => false,
      );
}
