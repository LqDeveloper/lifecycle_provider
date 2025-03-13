class ControllerConfig {
  static final ControllerConfig instance = ControllerConfig._();

  factory ControllerConfig() => instance;

  ControllerConfig._();

  bool controllerLog = true;

  bool globalStateLog = true;
}
