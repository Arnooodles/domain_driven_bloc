import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/app/generated/localization.g.dart';
import 'package:very_good_core/core/presentation/widgets/dialogs/confirmation_dialog.dart';

import '../../../utils/generated_mocks.mocks.dart';
import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_localization.dart';
import '../../../utils/test_utils.dart';

void main() {
  late MockAppLocalizationBloc appLocalizationBloc;

  setUp(() {
    appLocalizationBloc = MockAppLocalizationBloc();

    when(appLocalizationBloc.state).thenAnswer((_) => AppLocale.values.first.buildSync());
  });

  tearDown(() {
    appLocalizationBloc.close();
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
              appLocalizationBloc: appLocalizationBloc,
              child: const ConfirmationDialog(message: 'message'),
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'with title',
            builder: () => MockLocalization(
              appLocalizationBloc: appLocalizationBloc,
              child: const ConfirmationDialog(message: 'message', title: 'title'),
            ),
          ),
        ],
      ),
    );
  });
}
