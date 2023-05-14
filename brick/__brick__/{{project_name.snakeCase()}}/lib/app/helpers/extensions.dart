import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/generated/l10n.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/hidable_controller.dart';

// ignore_for_file: prefer-match-file-name,invalid_use_of_protected_member
// ignore_for_file: invalid_use_of_visible_for_testing_member,prefer-enums-by-name
extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;
}

extension CubitX<S> on Cubit<S> {
  void safeEmit(S state) {
    if (isClosed) return;
    emit(state);
  }
}

extension EitherX<L, R> on Either<L, R> {
  R asRight() => (this as Right<L, R>).value;
  L asLeft() => (this as Left<L, R>).value;
}

extension StatusCodeX on StatusCode {
  bool get isSuccess => value == 200 || value == 201 || value == 204;
}

extension IntX on int {
  StatusCode get statusCode => StatusCode.values.firstWhere(
        (StatusCode element) => element.value == this,
        orElse: () => StatusCode.http000,
      );
}

extension DateTimeX on DateTime {
  String defaultFormat() => DateFormat('MMM dd, yyyy').format(this);

  String get ago => timeago.format(
        DateTime.now()
            .toUtc()
            .subtract(DateTime.now().toUtc().difference(this)),
      );
}

extension ColorX on Color {
  String _generateAlpha({required int alpha, required bool withAlpha}) =>
      withAlpha ? alpha.toRadixString(16).padLeft(2, '0') : '';

  String toHex({bool hashSign = false, bool withAlpha = false}) =>
      '${hashSign ? '#' : ''}'
              '${_generateAlpha(alpha: alpha, withAlpha: withAlpha)}'
              '${red.toRadixString(16).padLeft(2, '0')}'
              '${green.toRadixString(16).padLeft(2, '0')}'
              '${blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();

  static Color fromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension HidableControllerX on ScrollController {
  static final Map<int, HidableController> hidableControllers =
      <int, HidableController>{};

  /// Shortcut way of creating hidable controller
  HidableController hidable(double size) {
    // If the same instance was created before, we should keep using it.
    if (hidableControllers.containsKey(hashCode)) {
      return hidableControllers[hashCode]!;
    }

    return hidableControllers[hashCode] = HidableController(
      scrollController: this,
      size: size,
    );
  }
}
