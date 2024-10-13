import 'package:lifecycle_provider/lifecycle_provider.dart';

class BasePageController<T extends Enum> extends BaseController<T> {
  @override
  List<T> get shouldNotifyIds => [];

  @override
  void onPageStart() {
    super.onPageStart();
    logMessage("$runtimeType ---onPageStart");
  }

  @override
  void onPageStop() {
    super.onPageStop();
    logMessage("$runtimeType ---onPageStop");
  }
}
