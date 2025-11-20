class ScreenConstraints {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static bool isMobile(double width) => width < mobileBreakpoint;
  static bool isTablet(double width) =>
      width >= mobileBreakpoint && width < tabletBreakpoint;
  static bool isDesktop(double width) => width >= tabletBreakpoint;
}
