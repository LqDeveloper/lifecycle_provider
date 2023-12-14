import 'event_bus.dart';

class GlobalEventBus {
  static final GlobalEventBus _instance = GlobalEventBus._();

  factory GlobalEventBus() {
    return _instance;
  }

  GlobalEventBus._() : _eventBus = EventBus();

  final EventBus _eventBus;

  static Stream<T> on<T>() {
    return _instance._eventBus.on<T>();
  }

  static void fire(event) {
    _instance._eventBus.fire(event);
  }
}
