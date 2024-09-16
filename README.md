## lifecycle_provider的优势

1. 和组件的生命周期，页面的路由做了绑定
2. 跨页面间数据通信，并且不需要有共同的父Controller
3. 基于Event的事件局部更新，调试更新widget的更加方便
4. 可以基于BaseController，添加Mixin ,方便业务逻辑解耦和复用

## 监听路由变化

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(

    ///需要将状态管理的路由监听添加到navigatorObservers中
    navigatorObservers: [LifecycleRouteObserver()],
  );
}

```

## 状态管理中生命周期介绍

```dart

enum LifecycleState {
  ///对应于State中的initState
  ///只会执行一次
  onPageInit,

  ///onPageInit之后，会立刻调用这个方法，并且只会调用一次，
  ///在这个方法里面可以根据context获取到其他InheritWidget中的数据，可以获取路由传过来的参数
  ///这个方法之后会调用State的Build方法，也就是在这个方法里面不需要再调用notifyListeners方法了
  ///只会执行一次
  onPageContextReady,

  ///这个方法会在Widget的第一帧，渲染完成之后调用，在这个方法里面一般用来做初始化的网络请求操作
  ///只会执行一次
  onPagePostFrame,

  ///这个方法会在页面显示时候调用，路由的切换，PageView（前提是设置了pageIndex）的切换都会调用
  ///可能会执行多次
  onPageStart,

  ///这个方法会在页面显示并能响应用户操作的时候调用，路由的切换，PageView（前提是设置了pageIndex）的切换都会调用
  ///当Dialog，或者BottomSheet pop的时候，下面的页面会调用这个方法
  ///可能会执行多次
  onPageResume,

  ///进入页面的动画结束
  ///只会执行一次
  onPageEnterAnimationEnd,

  ///这个方法会在页面显示不能响应用户操作的时候调用，路由的切换，PageView（前提是设置了pageIndex）的切换都会调用
  ///当Dialog，或者BottomSheet 显示的时候，下面的页面会调用这个方法
  ///可能会执行多次
  onPagePause,

  ///这个方法会在页面不显示时候调用，路由的切换，PageView（前提是设置了pageIndex）的切换都会调用
  ///可能会执行多次
  onPageStop,

  ///退出页面的动画结束，可能不回调用，比如在使用replace方法进行路由切换的时候，就不会调用这个方法
  ///只会执行一次
  onPageLeaveAnimationEnd,

  ///当页面销毁的时候调用
  ///只会执行一次
  onPageDispose,

  ///AppLifecycleState.resumed
  onAppResume,
  
  ///AppLifecycleState.inactive
  onAppInactive,

  ///AppLifecycleState.paused
  onAppPause,

  ///当App从后台进入前台的时候调用
  onAppForeground,

  ///当页面从前台进入后台的时候调用
  onAppBackground;
}


```

## 如何更新组件

使用状态管理的Controller可以继承自BaseController或者with NotifyMixin, LifecycleMixin

常用的Mixin

1. EventBusMixin: 用来实现跨页面通信的
2. LifecycleMixin： 用来和State的声明周期做绑定的
3. NotifyMixin： 基于事件对组件更新

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
}


```

```dart

enum UpdatePageEvent { update }

class UpdatePageController extends BasePageController<UpdatePageEvent> {
  @override
  List<UpdatePageEvent> get shouldNotifyIds => UpdatePageEvent.values;

  int _count = 0;

  int get count => _count;

  void increase() {
    _count++;
    notifySingleListener(UpdatePageEvent.update);
  }
}



class UpdatePage extends BasePage<UpdatePageController> {
  const UpdatePage({super.key});

  @override
  UpdatePageController createController(BuildContext context) {
    return UpdatePageController();
  }

  @override
  Widget providerStateBuild(
      BuildContext context, UpdatePageController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdatePage'),
      ),
      body: Center(
        child: SelectorIds<UpdatePageEvent, UpdatePageController>(
            ids: const [UpdatePageEvent.update],
            builder: (_, controller, __) {
              return Text('当前的值是：${controller.count}');
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

## 如何实现跨页面通信

```dart
class PageOneController extends BasePageController{
  ///发送事件
  void sendLoginEvent() {
    dispatchEvent(const LoginEvent(true));
  }
}


class PageTwoController extends BasePageController{
  @override
  void onInit() {
    super.onInit();

    ///监听事件
    observeEvent<LoginEvent>((event) {
      debugPrint('接收到了登录事件----${event.isLogin}');
    });
  }
}

```