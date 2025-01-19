import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/core/domain/bloc/app_localization/app_localization_bloc.dart';

class MockLocalization extends StatelessWidget {
  const MockLocalization({
    required this.child,
    required this.appLocalizationBloc,
    super.key,
  });

  final Widget child;
  final AppLocalizationBloc appLocalizationBloc;

  @override
  Widget build(BuildContext context) => BlocProvider<AppLocalizationBloc>(
        create: (BuildContext context) => appLocalizationBloc,
        child: Localizations(
          locale: const Locale('en'),
          delegates: Constant.localizationDelegates,
          child: child,
        ),
      );
}
