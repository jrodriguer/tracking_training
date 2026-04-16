enum AppBreakpoint { phone, tablet, desktop }

AppBreakpoint breakpointForWidth(double width) {
  if (width < 700) {
    return AppBreakpoint.phone;
  }

  if (width < 1100) {
    return AppBreakpoint.tablet;
  }

  return AppBreakpoint.desktop;
}
