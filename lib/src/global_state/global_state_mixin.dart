import 'package:flutter/foundation.dart';

import 'base_global_state.dart';
import 'global_state_manager.dart';

mixin GlobalStateMixin on ChangeNotifier {
  final Map<String, BaseGlobalState> _cacheState = {};

  GlobalStateManager get _manager => GlobalStateManager.instance;

  @protected
  bool hasGlobalState({String? tag}) {
    return _manager.hasRegister(tag: tag);
  }

  @protected
  T? registerGlobalState<T extends BaseGlobalState>(T state, {String? tag}) {
    _manager.register(state, tag: tag);
    return getGlobalState(tag: tag);
  }

  @protected
  T? getGlobalState<T extends BaseGlobalState>({String? tag}) {
    final key = _manager.getTagKey<T>(tag);
    if (_cacheState.containsKey(key)) {
      return _cacheState[key]! as T;
    } else {
      final state = _manager.getState<T>(tag: tag);
      if (state == null) {
        return null;
      }
      _cacheState[key] = state;
      return state;
    }
  }

  @protected
  void resetGlobalState() {
    _manager.resetAllState();
  }

  @override
  void dispose() {
    for (final key in _cacheState.keys) {
      _manager.releaseWithKey(key);
    }
    super.dispose();
  }
}
