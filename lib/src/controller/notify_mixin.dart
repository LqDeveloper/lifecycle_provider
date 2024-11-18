import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'package:meta/meta.dart';

class _State<T> {
  final T name;

  int _value = 0;

  int get value => _value;

  _State({required this.name});

  void increasedTag() {
    if (_value > 10) {
      _value = 0;
    }
    _value++;
  }
}

mixin NotifyMixin<T extends Enum> on ChangeNotifier {
  bool _disposed = false;

  bool get shouldLog => true;

  final Map<T, _State> _updatedIds = {};

  bool _hasRegister = false;

  @protected
  @mustCallSuper
  @override
  void dispose() {
    logMessage("-- dispose");
    _disposed = true;
    _updatedIds.clear();
    super.dispose();
  }

  @protected
  @mustCallSuper
  void registerIds(List<T> ids) {
    clearRegisteredIds();
    logMessage("--register--ids: $ids");
    for (T name in ids) {
      _updatedIds[name] = _State(name: name);
    }
    _hasRegister = true;
  }

  @protected
  @mustCallSuper
  void clearRegisteredIds() {
    _updatedIds.clear();
  }

  @protected
  @mustCallSuper
  void clearSingleId(String id) {
    _updatedIds.remove(id);
  }

  @protected
  @mustCallSuper
  @override
  void notifyListeners() {
    if (!_disposed) {
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          super.notifyListeners();
        });
      } else {
        super.notifyListeners();
      }
    }
  }

  @protected
  @mustCallSuper
  void notifyMultiListeners(List<T> ids) {
    if (_disposed) {
      return;
    }
    assert(_hasRegister, '${runtimeType.toString()}: registerIds not call');
    logMessage("--update--ids: $ids");
    if (ids.isEmpty) {
      return;
    }
    for (T id in ids) {
      assert(containsId(id),
          '${runtimeType.toString()}: Id: $id must be register');
      _updatedIds[id]?.increasedTag();
    }
    observeNotifyEvent(ids);
    notifyListeners();
  }

  @protected
  @mustCallSuper
  void notifySingleListener(T id) {
    if (_disposed) {
      return;
    }
    assert(_hasRegister, '${runtimeType.toString()}: registerIds not call');
    logMessage("--更新了--id: $id ");
    assert(
        containsId(id), '${runtimeType.toString()}: id: $id must be register');
    _updatedIds[id]?.increasedTag();
    observeNotifyEvent([id]);
    notifyListeners();
  }

  @internal
  bool containsId(T id) {
    return _updatedIds.containsKey(id);
  }

  @internal
  bool containsMultiId(List<T> ids) {
    for (T id in ids) {
      if (!containsId(id)) {
        assert(containsId(id),
            '${runtimeType.toString()}: id: $id must be register');
        return false;
      }
    }
    return true;
  }

  @internal
  int updateIdValue(T id) {
    return _updatedIds[id]?.value ?? 0;
  }

  @internal
  int updateMultiIdValue(List<T> ids) {
    int value = 0;
    for (T id in ids) {
      value += updateIdValue(id);
    }
    return value;
  }

  @protected
  void logMessage(String message) {
    if (kDebugMode && shouldLog) {
      debugPrint("${runtimeType.toString()}: $message");
    }
  }

  @protected
  void observeNotifyEvent(List<T> events) {}
}
