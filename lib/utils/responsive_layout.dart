import 'package:flutter/material.dart';

enum ScreenSizes {
  mobile(600),
  tablet(880),
  desktop(2000),
  tv(4000);

  const ScreenSizes(this.value);
  final int value;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile.value;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet.value;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width < desktop.value;
  static bool isTV(BuildContext context) =>
      MediaQuery.of(context).size.width < tv.value;
}

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  });
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (mobile != null && constraints.maxWidth < ScreenSizes.mobile.value) {
          return mobile!;
        } else if (tablet != null &&
            constraints.maxWidth < ScreenSizes.tablet.value) {
          return tablet!;
        }
        return desktop ?? const Placeholder();
      },
    );
  }
}
