import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:very_good_core/app/constants/enum.dart';
import 'package:very_good_core/app/utils/connectivity_utils.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/app/utils/injection.dart';

class ConnectivityChecker extends HookWidget {
  const ConnectivityChecker({super.key, required this.child});

  final Widget child;

  static Widget scaffold({
    required Widget body,
    Color? backgroundColor,
  }) =>
      ConnectivityChecker(
        child: Scaffold(
          body: SafeArea(child: body),
          backgroundColor: backgroundColor,
        ),
      );

  StreamSubscription<T> useStreamSubscription<T>(
    Stream<T> stream,
    void Function(T event) onData,
  ) {
    final StreamSubscription<T> subscription =
        useMemoized(() => stream.listen(onData), <Object>[stream, onData]);
    useEffect(
      () => subscription.cancel,
      <Object>[subscription],
    );

    return subscription;
  }

  @override
  Widget build(BuildContext context) {
    final ConnectivityUtils connectivityUtils = getIt<ConnectivityUtils>();
    final ValueNotifier<bool> isDialogShowing = useState<bool>(false);

    useStreamSubscription<ConnectionStatus>(
      connectivityUtils.internetStatus(),
      (ConnectionStatus event) async {
        if (event == ConnectionStatus.offline && !isDialogShowing.value) {
          isDialogShowing.value = true;
          await DialogUtils.showOfflineDialog(context);
          isDialogShowing.value = false;
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await connectivityUtils.checkInternet() == ConnectionStatus.offline &&
          !isDialogShowing.value) {
        isDialogShowing.value = true;
        await DialogUtils.showOfflineDialog(context);
        isDialogShowing.value = false;
      }
    });

    return child;
  }
}
