// prefer_const_constructors is ignored to ensure the constructor is hit by code coverage.
// ignore_for_file: discarded_futures, prefer_const_constructors

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/localization.g.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/dialogs/confirmation_dialog.dart';

import '../../../utils/generated_mocks.mocks.dart';
import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_localization.dart';
import '../../../utils/test_utils.dart';

void main() {
  late MockAppLocalizationCubit appLocalizationCubit;

  setUp(() {
    appLocalizationCubit = MockAppLocalizationCubit();

    when(appLocalizationCubit.state).thenAnswer((_) => AppLocale.values.first.buildSync());
  });

  tearDown(() async {
    await appLocalizationCubit.close();
  });

  group(ConfirmationDialog, () {
    goldenTest(
      'renders correctly',
      fileName: 'confirmation_dialog'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'default',
            builder: () => MockLocalization(
              appLocalizationCubit: appLocalizationCubit,
              child: ConfirmationDialog(message: 'message'),
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'with title',
            builder: () => MockLocalization(
              appLocalizationCubit: appLocalizationCubit,
              child: ConfirmationDialog(message: 'message', title: 'title'),
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'with all parameters',
            builder: () => MockLocalization(
              appLocalizationCubit: appLocalizationCubit,
              child: ConfirmationDialog(
                message: 'message',
                title: 'title',
                titleColor: Colors.red,
                negativeButtonText: 'Cancel',
                positiveButtonText: 'Confirm',
                negativeButtonTextColor: Colors.blue,
                positiveButtonTextColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  });
}
