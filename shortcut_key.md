
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