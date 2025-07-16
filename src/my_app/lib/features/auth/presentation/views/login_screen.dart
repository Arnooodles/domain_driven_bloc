import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/core/domain/entity/enum/text_field_type.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_button.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text_field.dart';
import 'package:very_good_core/core/presentation/widgets/wrappers/connectivity_checker.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:very_good_core/features/auth/domain/bloc/login/login_bloc.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  void _onPopInvoked(BuildContext context, bool didPop) {
    if (!didPop) {
      DialogUtils.showExitDialog(context);
    }
  }

  void _onLoginStateChangedListener(BuildContext context, LoginPresentationEvent event) {
    event.when(onSuccess: () => context.read<AuthBloc>().authenticate());
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordTextController = useTextEditingController();
    final TextEditingController usernameTextController = useTextEditingController();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) => _onPopInvoked(context, didPop),
      child: BlocProvider<LoginBloc>(
        create: (BuildContext context) => getIt<LoginBloc>()..initialize(),
        child: BlocPresentationListener<LoginBloc, LoginPresentationEvent>(
          listener: _onLoginStateChangedListener,
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (BuildContext context, LoginState state) {
              final String currentUsername = state.username ?? '';
              usernameTextController
                ..value = TextEditingValue(text: currentUsername)
                ..selection = TextSelection.fromPosition(TextPosition(offset: currentUsername.length));

              return ConnectivityChecker.scaffold(
                isUnfocusable: true,
                body: Center(
                  child: Container(
                    padding: Paddings.allXLarge,
                    constraints: const BoxConstraints(maxWidth: Constant.mobileBreakpoint),
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: Center(
                            child: VeryGoodCoreText(
                              text: Constant.appName,
                              textAlign: TextAlign.center,
                              style: context.textTheme.displayLarge,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              VeryGoodCoreTextField(
                                controller: usernameTextController,
                                labelText: context.i18n.login.label.username,
                                hintText: context.i18n.login.hint.username,
                                onChanged: (String value) => context.read<LoginBloc>().onUsernameChanged(value),
                                autofocus: true,
                              ),
                              Gap.large(),
                              VeryGoodCoreTextField(
                                controller: passwordTextController,
                                labelText: context.i18n.login.label.password,
                                hintText: context.i18n.login.hint.password,
                                textFieldType: TextFieldType.password,
                              ),
                              Gap.xxxLarge(),
                              VeryGoodCoreButton(
                                text: context.i18n.login.button.login,
                                isEnabled: !state.isLoading,
                                isLoading: state.isLoading,
                                isExpanded: true,
                                onPressed: () => context.read<LoginBloc>().login(
                                  usernameTextController.text,
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
      ),
    );
  }
}
