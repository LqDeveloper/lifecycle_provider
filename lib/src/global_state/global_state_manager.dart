import 'package:meta/meta.dart';

import '../config/controller_config.dart';
import '../config/log_utils.dart';
import 'base_global_state.dart';

class _ReferenceCountState {
  final BaseGlobalState state;
  int count;

  _ReferenceCountState({required this.state, required this.count});

  @override
  String toString() {
    return "(${state.runtimeType}  referenceCount:$count)";
  }
}

@internal
class GlobalStateManager {
  static final GlobalStateManager instance = GlobalStateManager._();

  factory GlobalStateManager() => instance;

  GlobalStateManager._();

  final Map<String, _ReferenceCountState> _globalState = {};

  String getTagKey<T>(String? tag) {
    final key = T.toString();
    return (tag == null || tag.isEmpty) ? key : "${key}_$tag";
  }

  bool hasRegister<T extends BaseGlobalState>({String? tag}) {
    final key = getTagKey<T>(tag);
    return _globalState.containsKey(key);
  }

  void register<T extends BaseGlobalState>(T state, {String? tag}) {
    final key = getTagKey<T>(tag);
    if (_globalState.containsKey(key)) {
      _debugGlobalData("Warning: ${state.runtimeType}  has been registered");
      return;
    }
    _globalState[key] = _ReferenceCountState(state: state, count: 0);
    _debugGlobalData("Add: ${state.runtimeType}");
  }

  T? getState<T extends BaseGlobalState>({String? tag}) {
    final key = getTagKey<T>(tag);
    if (!_globalState.containsKey(key)) {
      _debugGlobalData("Warning: $T has not been registered");
      return null;
    }
    final referenceState = _globalState[key]!;
    referenceState.count++;
    _debugGlobalData(
      "Retain: ${referenceState.state.runtimeType} referenceCount:${referenceState.count}",
    );
    return referenceState.state as T;
  }

  void releaseWithKey(String key) {
    if (!_globalState.containsKey(key)) {
      return;
    }
    final referenceState = _globalState[key]!;
    if (!referenceState.state.autoDispose) {
      return;
    }
    referenceState.count--;
    _debugGlobalData(
      "Release: ${referenceState.state.runtimeType} referenceCount:${referenceState.count}",
    );
    if (referenceState.count == 0) {
      _globalState.remove(key);
      _debugGlobalData("Dispose: ${referenceState.state.runtimeType}");
    }
  }

  void disposeWithKey(String key) {
    if (!_globalState.containsKey(key)) {
      return;
    }
    _globalState.remove(key);
    _debugGlobalData("Dispose: ${_globalState[key]!.state.runtimeType}");
  }

  void resetAllState() {
    _globalState.clear();
    LogUtils.d("Remove all global state");
  }

  void _debugGlobalData(String desc) {
    if (!ControllerConfig.instance.globalStateLog) {
      return;
    }
    LogUtils.d('''
          **************************************************
          $desc
          **************************************************
          GlobalStorage: $_globalState
          **************************************************
          ''');
  }
}
