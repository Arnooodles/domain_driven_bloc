import 'package:trust_but_verify/trust_but_verify.dart';

extension SyncValidationExt on SyncValidationStep<String> {
  SyncValidationStep<String> isUrlStrict() => bind((String value) {
    const Set<String> allowedSchemes = <String>{'http', 'https'};
    final String sanitized = value.trim();
    final Uri? uri = Uri.tryParse(sanitized);
    final bool hasAllowedScheme = uri != null && uri.hasScheme && allowedSchemes.contains(uri.scheme.toLowerCase());
    final bool hasAuthority = uri?.hasAuthority ?? false;
    final bool hasNoInnerSpaces = !sanitized.contains(' ');
    final bool hasNoOuterSpaces = sanitized == value;

    final bool isValid = hasAllowedScheme && hasAuthority && hasNoInnerSpaces && hasNoOuterSpaces;

    return isValid ? pass(value) : fail(InvalidUrlValidationError.new, ValidationI18n.messages.invalidUrl(fieldName));
  });
}
