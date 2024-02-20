import 'package:meta/meta.dart';

@internal
abstract class LifecycleRouteAware {
  void routePageStart();

  void routePageResume();

  void routePagePause();

  void routePageStop();
}
