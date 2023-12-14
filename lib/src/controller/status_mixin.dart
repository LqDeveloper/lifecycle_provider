import 'dart:async';

import 'package:flutter/foundation.dart';

enum PageStatus { idle, loading, failure }

mixin StatusMixin on ChangeNotifier {
  final StreamController<PageStatus> _controller = StreamController.broadcast();

  Stream<PageStatus> get statusStream => _controller.stream;

  @protected
  void setIdle() {
    _controller.add(PageStatus.idle);
  }

  @protected
  void setLoading() {
    _controller.add(PageStatus.loading);
  }

  @protected
  void setFailure() {
    _controller.add(PageStatus.failure);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
