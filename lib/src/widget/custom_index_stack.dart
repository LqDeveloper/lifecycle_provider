import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomIndexedStack extends IndexedStack {
  const CustomIndexedStack({
    super.key,
    super.alignment = AlignmentDirectional.topStart,
    super.textDirection,
    super.clipBehavior = Clip.hardEdge,
    super.sizing = StackFit.loose,
    super.index = 0,
    super.children = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> wrappedChildren =
        List<Widget>.generate(children.length, (int i) {
      return Visibility.maintain(
        visible: i == index,
        child: children[i],
      );
    });
    return _CustomRawIndexedStack(
      alignment: alignment,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      sizing: sizing,
      index: index,
      children: wrappedChildren,
    );
  }
}

class _CustomRawIndexedStack extends Stack {
  const _CustomRawIndexedStack({
    super.alignment,
    super.textDirection,
    super.clipBehavior,
    StackFit sizing = StackFit.loose,
    this.index = 0,
    super.children,
  }) : super(fit: sizing);

  final int? index;

  @override
  CustomRenderIndexedStack createRenderObject(BuildContext context) {
    return CustomRenderIndexedStack(
      index: index,
      fit: fit,
      clipBehavior: clipBehavior,
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, CustomRenderIndexedStack renderObject) {
    renderObject
      ..index = index
      ..fit = fit
      ..clipBehavior = clipBehavior
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.maybeOf(context);
  }

  @override
  MultiChildRenderObjectElement createElement() {
    return _IndexedStackElement(this);
  }
}

class _IndexedStackElement extends MultiChildRenderObjectElement {
  _IndexedStackElement(_CustomRawIndexedStack super.widget);

  @override
  _CustomRawIndexedStack get widget => super.widget as _CustomRawIndexedStack;

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    final int? index = widget.index;
    if (index != null && children.isNotEmpty) {
      visitor(children.elementAt(index));
    }
  }
}

class CustomRenderIndexedStack extends RenderIndexedStack {
  final StreamController<int?> _controller = StreamController.broadcast();

  Stream<int?> get stream => _controller.stream;

  CustomRenderIndexedStack({
    super.children,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    super.index,
  });

  @override
  set index(int? value) {
    super.index = value;
    _controller.add(value);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
