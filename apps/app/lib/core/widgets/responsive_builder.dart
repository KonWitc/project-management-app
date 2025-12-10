import 'package:flutter/material.dart';

enum DeviceSize {
  mobile,
  tablet,
  desktop,
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceSize size) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  static DeviceSize getDeviceSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1100) return DeviceSize.desktop;
    if (width >= 700) return DeviceSize.tablet;
    return DeviceSize.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final size = getDeviceSize(context);
    return builder(context, size);
  }
}
