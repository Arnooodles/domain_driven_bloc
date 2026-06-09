import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

Future<void> run(HookContext context) async {
  final logger = context.logger;

  // The output directory where the brick was generated
  final outputDir = Directory.current.path;
  final projectName = context.vars['project_name'] as String;
  final snakeCaseProjectName = projectName.snakeCase;

  // The path to the scripts directory in the generated project
  final scriptsPath = p.join(outputDir, snakeCaseProjectName, 'scripts');
  final binaryPath = p.join(scriptsPath, 'MQSwiftSign');

  // URL to download MQSwiftSign from.
  const downloadUrl =
      'https://raw.githubusercontent.com/Arnooodles/domain_driven_bloc/main/src/my_app/scripts/MQSwiftSign';

  logger.info('Downloading MQSwiftSign binary...');

  try {
    // Ensure scripts directory exists
    final scriptsDir = Directory(scriptsPath);
    if (!scriptsDir.existsSync()) {
      scriptsDir.createSync(recursive: true);
    }

    // Download the binary
    final response = await http.get(Uri.parse(downloadUrl));
    if (response.statusCode == 200) {
      File(binaryPath).writeAsBytesSync(response.bodyBytes);

      // Make the binary executable
      if (Platform.isLinux || Platform.isMacOS) {
        await Process.run('chmod', ['+x', binaryPath]);
      }
      logger.success('Successfully downloaded MQSwiftSign.');
    } else {
      logger.err('Failed to download MQSwiftSign. HTTP Status: ${response.statusCode}');
    }
  } on Exception catch (e) {
    logger.err('An error occurred while downloading MQSwiftSign: $e');
  }
}
