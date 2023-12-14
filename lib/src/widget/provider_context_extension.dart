import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

extension ProviderContextExtension on BuildContext {
  T rc<T>() {
    return Provider.of<T>(this, listen: false);
  }
}
