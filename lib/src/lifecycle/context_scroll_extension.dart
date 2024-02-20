import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

extension ContextScrollExtension on BuildContext {
  T? findAncestorRenderObj<T extends RenderObject>({int maxCycleCount = 10}) {
    final obj = findRenderObject();
    if (obj == null) {
      return null;
    }
    int currentCycleCount = 1;
    var parent = obj.parent;
    while (parent != null && currentCycleCount <= maxCycleCount) {
      if (parent is T) {
        return parent;
      }
      parent = parent.parent;
      currentCycleCount++;
    }
    return null;
  }

  RenderViewportBase? findViewport({int maxCycleCount = 10}) {
    return findAncestorRenderObj<RenderViewportBase>(
        maxCycleCount: maxCycleCount);
  }

  RenderAbstractViewport? findViewportToRoot() {
    return RenderAbstractViewport.maybeOf(findRenderObject());
  }

  bool isInScrollView(RenderAbstractViewport? viewport) {
    return viewport != null;
  }
}
