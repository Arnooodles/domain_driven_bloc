import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/error_message_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/injection.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/{{project_name.snakeCase()}}/{{project_name.snakeCase()}}_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/app_title.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/connectivity_checker.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_button.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text_field.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/login_bloc.dart';

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
        listener: _loginScreenListener,
        builder: (BuildContext context, LoginState state) {
          emailTextController
            ..value = TextEditingValue(text: state.emailAddress ?? '')
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: emailTextController.text.length),
            );

          return ConnectivityChecker.scaffold(
            body: Center(
              child: Container(
                constraints:
                    const BoxConstraints(maxWidth: Constant.mobileBreakpoint),
                padding: EdgeInsets.all(Insets.xl),
                child: Column(
                  children: <Widget>[
                    const Flexible(
                      child: Center(
                        child: AppTitle(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          VeryGoodCoreTextField(
                            labelText: context.l10n.login__label_text__email,
                            controller: emailTextController,
                            autofocus: true,
                            hintText:
                                context.l10n.login__text_field_hint__email,
                            onChanged: (String value) => context
                                .read<LoginBloc>()
                                .onEmailAddressChanged(value),
                          ),
                          VSpace.lg,
                          VeryGoodCoreTextField(
                            labelText: context.l10n.login__label_text__password,
                            controller: passwordTextController,
                            isPassword: true,
                            textInputType: TextInputType.visiblePassword,
                            hintText:
                                context.l10n.login__text_field_hint__password,
                          ),
                          VSpace.xxl,
                          VeryGoodCoreButton(
                            isExpanded: true,
                            isEnabled: !state.isLoading,
                            onPressed: () => context.read<LoginBloc>().login(
                                  emailTextController.text,
                                  passwordTextController.text,
                                ),
                            text: context.l10n.login__button_text__login,
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
    );
  }

  void _loginScreenListener(BuildContext context, LoginState state) {
    if (state.isSuccess) {
      context.read<VeryGoodCoreBloc>().authenticate();
    } else if (state.failure != null) {
      DialogUtils.showSnackbar(
        context,
        ErrorMessageUtils.generate(context, state.failure),
      );
    }
  }
}
