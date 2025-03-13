import 'package:lifecycle_provider/lifecycle_provider.dart';

class PersonInfo extends BaseGlobalState {
  final String name;

  final int age;

  PersonInfo(this.name, this.age) : super(autoDispose: true);

  @override
  String toString() {
    return "PersonInfo(name:$name age:$age)";
  }
}
