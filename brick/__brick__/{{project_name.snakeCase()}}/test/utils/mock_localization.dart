import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/cubit/app_localization/app_localization_cubit.dart';

class MockLocalization extends StatelessWidget {
  const MockLocalization({required this.child, required this.appLocalizationCubit, super.key});

  final Widget child;
  final AppLocalizationCubit appLocalizationCubit;

  @override
  Widget build(BuildContext context) => BlocProvider<AppLocalizationCubit>(
    create: (BuildContext context) => appLocalizationCubit,
    child: Localizations(locale: const Locale('en'), delegates: Constant.localizationDelegates, child: child),
  );
}
