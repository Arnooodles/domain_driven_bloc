import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/error_message_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/button_type.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/text_field_type.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/app_title.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_button.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text_field.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/connectivity_checker.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/login/login_bloc.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  void _onPopInvoked(BuildContext context, bool didPop) {
    if (!didPop) {
      DialogUtils.showExitDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordTextController =
        useTextEditingController();
    final TextEditingController emailTextController =
        useTextEditingController();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) =>
          _onPopInvoked(context, didPop),
      child: BlocProvider<LoginBloc>(
        create: (BuildContext context) => getIt<LoginBloc>(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: _onStateChangedListener,
          builder: (BuildContext context, LoginState state) {
            emailTextController
              ..value = TextEditingValue(text: state.emailAddress ?? '')
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: emailTextController.text.length),
              );

            return ConnectivityChecker.scaffold(
              isUnfocusable: true,
              backgroundColor: context.colorScheme.surface,
              body: Center(
                child: Container(
                  padding: Paddings.allXLarge,
                  constraints: const BoxConstraints(
                    maxWidth: Constant.mobileBreakpoint,
                  ),
                  child: Column(
                    children: <Widget>[
                      const Flexible(child: Center(child: AppTitle())),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            {{#pascalCase}}{{project_name}}{{/pascalCase}}TextField(
                              controller: emailTextController,
                              labelText: context.i18n.login.label.email,
                              hintText: context.i18n.login.hint.email,
                              onChanged: (String value) => context
                                  .read<LoginBloc>()
                                  .onEmailAddressChanged(value),
                              autofocus: true,
                            ),
                            Gap.large(),
                            {{#pascalCase}}{{project_name}}{{/pascalCase}}TextField(
                              controller: passwordTextController,
                              labelText: context.i18n.login.label.password,
                              hintText: context.i18n.login.hint.password,
                              textFieldType: TextFieldType.password,
                            ),
                            Gap.xxxLarge(),
                            {{#pascalCase}}{{project_name}}{{/pascalCase}}Button(
                              text: context.i18n.login.button.login,
                              isEnabled: !state.isLoading,
                              isExpanded: true,
                              buttonType: ButtonType.filled,
                              onPressed: () => context.read<LoginBloc>().login(
                                    emailTextController.text,
                                    passwordTextController.text,
                                  ),
                              contentPadding: Paddings.verticalSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onStateChangedListener(BuildContext context, LoginState state) {
    state.loginStatus.whenOrNull(
      success: () => context.read<AuthBloc>().authenticate(),
      failed: (Failure failure) => DialogUtils.showError(
        context,
        ErrorMessageUtils.generate(context, failure),
      ),
    );
  }
}
