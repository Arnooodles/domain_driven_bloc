import 'package:flutter/material.dart';

class UnfocusableScaffold extends StatelessWidget {
  const UnfocusableScaffold({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
  });

  final VoidCallback? onTap;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap ?? () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: body,
          appBar: appBar,
          backgroundColor: backgroundColor,
          bottomNavigationBar: bottomNavigationBar,
        ),
      );
}
