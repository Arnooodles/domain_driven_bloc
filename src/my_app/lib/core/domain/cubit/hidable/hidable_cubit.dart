import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';

@lazySingleton
class HidableCubit extends Cubit<bool> {
  HidableCubit() : super(true);

  void setVisibility({required bool isVisible}) => safeEmit(isVisible);
}
