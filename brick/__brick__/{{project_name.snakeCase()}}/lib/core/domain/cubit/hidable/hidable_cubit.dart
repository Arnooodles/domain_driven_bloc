import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/cubit_ext.dart';

@injectable
class HidableCubit extends Cubit<bool> {
  HidableCubit() : super(true);

  void setVisibility({required bool isVisible}) => safeEmit(isVisible);
}
