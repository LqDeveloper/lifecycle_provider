## Advantages of lifecycle_provider

1. Binds with the lifecycle of components and page routes

2. Data communication across pages, and no need for a common parent Controller

3. Event-based partial update, debugging and updating widgets is more convenient

4. Add Mixin based on BaseController to facilitate business logic decoupling and reuse

## Listening for route changes

```dart

@override
Widget build(BuildContext context) {
  return MaterialApp(

    ///Need to add state management route listener to navigatorObservers
    navigatorObservers: [LifecycleRouteObserver()],
  );
}

```

## Introduction to lifecycle in state management

```dart

enum LifecycleState {
///Corresponds to initState in State
///Only executed once
onPageInit,

///After onPageInit, this method will be called immediately and only once,
///In this method, you can get the data in other InheritWidgets according to context, and you can get the parameters passed by the route
///This method will call the Build method of State later, that is, you don't need to call the notifyListeners method in this method
///Only execute once
onPageContextReady,

///This method will be called after the first frame of the Widget is rendered. This method is generally used to initialize the network request operation
///Only execute once
onPagePostFrame,

///This method will be called when the page is displayed, and the switching of routes and PageView (provided that pageIndex is set) will be called
///May be executed multiple times
onPageStart,

///This method will be called when the page is displayed and can respond to user operations, and the switching of routes and PageView (provided that pageIndex is set) will be called
///When Dialog or BottomSheet pops, the following page will call this method
///May be executed multiple times
onPageResume,

///The animation of entering the page ends
///Only execute once
onPageEnterAnimationEnd,

///This method will be called when the page display cannot respond to user operations. It will be called when the route is switched or PageView (provided that pageIndex is set) is switched.
///When Dialog or BottomSheet is displayed, the following page will call this method.
///It may be executed multiple times.
onPagePause,

///This method will be called when the page is not displayed. It will be called when the route is switched or PageView (provided that pageIndex is set).
///It may be executed multiple times.
onPageStop,

///When the animation of exiting the page ends, it may not be called back. For example, when the replace method is used to switch routes, this method will not be called.
///It will only be executed once.
onPageLeaveAnimationEnd,

///Called when the page is destroyed.
///It will only be executed once.
onPageDispose,

///AppLifecycleState.resumed
onAppResume,

///AppLifecycleState.inactive
onAppInactive,

///AppLifecycleState.paused
onAppPause,

///Called when App enters the foreground from the background
onAppForeground,

///Called when the page enters the background from the foreground
onAppBackground;
}

```

## How to update components

Controllers using state management can inherit from BaseController or with NotifyMixin, LifecycleMixin

Common Mixins

1. EventBusMixin: used to implement cross-page communication
2. LifecycleMixin: used to bind with the declaration cycle of State
3. NotifyMixin: Update components based on events

```dart

abstract class BaseController<T extends Enum> extends ChangeNotifier
    with NotifyMixin<T>, LifecycleMixin, EventBusMixin {
  @override
  @mustCallSuper
  void onPageInit() {
    super.onPageInit();
    registerIds(shouldNotifyIds);
  }

  List<T> get shouldNotifyIds;
} ``
`
`
`
`
dart
enum UpdatePageEvent { update }

class UpdatePageController extends BasePageController<UpdatePageEvent> {
  @override List<UpdatePageEvent> get shouldNotifyIds => UpdatePageEvent.values;
  int _count = 0;

  int get count => _count;

  void increase() {
    _count++;
    notifySingleListener(UpdatePageEvent.update);
  }
}

class UpdatePage extends BasePage<UpdatePageController> {
  const UpdatePage({super.key});

  @override UpdatePageController createController(BuildContext context) {
    return UpdatePageController();
  }

  @override Widget providerStateBuild(BuildContext context, UpdatePageController controller) {
    return Scaffold(appBar: AppBar(title: const Text('UpdatePage'),),
      body: Center(child: SelectorIds<UpdatePageEvent, UpdatePageController>(
          ids: const [UpdatePageEvent.update],
          builder: (_, controller, __) {
            return Text('Current value is: ${controller.count}');
          }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.increase(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

```

## How to implement cross-page communication

```dart
class PageOneController extends BasePageController {
  ///Send event
  void sendLoginEvent() {
    dispatchEvent(const LoginEvent(true));
  }
}

class PageTwoController extends BasePageController {
  @override
  void onInit() {
    super.onInit();

    ///Listen for events
    observeEvent<LoginEvent>((event) {
      debugPrint('Login event received----${event.isLogin}');
    });
  }
}

```

## Keyboard Shortcut
```dart
  // sid
  SelectorIds<$Controller$,$Event$ >(
        ids: const [],
        builder: (_, controller, __) {
          return const SizedBox();
        })

```

```dart
  // sview
class $Name$ extends SelectorIdsView<$Event$, $Controller$> {
  const $Name$({super.key});
  @override
  List<$Event$> get observeIds => [];

  @override
  Widget buildWidget(BuildContext context,  $Controller$ controller) {
    return const SizedBox();
  }
}
```

```dart
  // lcontro
enum $Name$Events { none }

class $Name$Controller extends BaseController<$Name$Events> {
  @override
  List<$Name$Events> get shouldNotifyIds => $Name$Events.values;

  @override
  void onPageInit() {
    super.onPageInit();
  }
}
```



```dart
  // lbase
class $Name$Page extends BasePage<$Name$Controller> {
  const $Name$Page({super.key});

  @override
  $Name$Controller createController(BuildContext context) {
    return $Name$Controller();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, $Name$Controller controller) {
    return const SizedBox();
  }
}
```