import 'package:alchemist/alchemist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/domain/entity/enum/text_type.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_text.dart';

import '../../utils/test_utils.dart';

void main() {
  const String markdownData = '''
  # Minimal Markdown Test
  ---
  This is a simple Markdown test. Provide a text string with Markdown tags
  to the Markdown widget and it will display the formatted output in a
  scrollable widget.

  ## Section 1
  Maecenas eget **arcu egestas**, mollis ex vitae, posuere magna. Nunc eget
  aliquam tortor. Vestibulum porta sodales efficitur. Mauris interdum turpis
  eget est condimentum, vitae porttitor diam ornare.

  ### Subsection A
  Sed et massa finibus, blandit massa vel, vulputate velit. Vestibulum vitae
  venenatis libero. **__Curabitur sem lectus, feugiat eu justo in, eleifend
  accumsan ante.__** Sed a fermentum elit. Curabitur sodales metus id mi
  ornare, in ullamcorper magna congue.
  ''';

  group(VeryGoodCoreText, () {
    goldenTest(
      'renders correctly',
      fileName: 'very_good_core_text'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'regular',
            child: const VeryGoodCoreText(text: 'text'),
          ),
          GoldenTestScenario(
            name: 'styled',
            child: const VeryGoodCoreText(text: '<b>styled</b> text', textType: TextType.styled),
          ),
          GoldenTestScenario(
            name: 'markdown',
            constraints: const BoxConstraints(maxWidth: 400),
            child: const SizedBox(
              width: 400,
              height: 400,
              child: VeryGoodCoreText(text: markdownData, textType: TextType.markdown),
            ),
          ),
          GoldenTestScenario(
            name: 'selectable',
            child: const VeryGoodCoreText(text: 'selectable text', textType: TextType.selectable),
          ),
        ],
      ),
    );
  });
}
