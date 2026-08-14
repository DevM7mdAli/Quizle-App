import 'package:flutter/foundation.dart';

abstract final class AppPaths {
  static const landing = '/';
  static const onboarding = '/onboarding';
  static const webApp = '/app';

  static String get home => kIsWeb ? webApp : landing;
}
