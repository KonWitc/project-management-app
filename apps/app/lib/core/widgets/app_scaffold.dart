import 'package:flutter/material.dart';
import 'package:app/core/widgets/responsive_builder.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final EdgeInsets? padding;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.padding,
  });

  static const double maxContentWidth = 1200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: ResponsiveBuilder(
        builder: (context, size) {
          if (size == DeviceSize.desktop) {
            return Center(
              child: Container(
                width: maxContentWidth,
                padding: padding ?? const EdgeInsets.all(24.0),
                child: body,
              ),
            );
          }

          return Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: body,
          );
        },
      ),
    );
  }
}