import 'package:lifecycle_provider/lifecycle_provider.dart';

class BasePageController extends BaseController {
  @override
  List<String> get shouldNotifyIds => [];

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
