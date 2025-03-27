import 'dart:async';

class EventBus {
  final StreamController<dynamic> _streamController;

  StreamController<dynamic> get streamController => _streamController;

  EventBus({bool sync = false})
    : _streamController = StreamController<dynamic>.broadcast(sync: sync);

  EventBus.customController(StreamController controller)
    : _streamController = controller;

  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void fire(event) {
    if (streamController.isClosed) {
      return;
    }
    streamController.add(event);
  }

  void destroy() {
    _streamController.close();
  }
}
