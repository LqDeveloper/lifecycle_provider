enum LifecycleState {
  onPageInit,
  onPageContextReady,
  onPagePostFrame,
  onPageReassemble,
  onPageStart,
  onPageResume,
  onPageEnterAnimationEnd,
  onPagePause,
  onPageStop,
  onPageLeaveAnimationEnd,
  onPageDispose,
  onAppResume,
  onAppInactive,
  onAppPause,
  onAppForeground,
  onAppBackground;

  bool get isPageResume => this == LifecycleState.onPageResume;

  bool get isPagePause => this == LifecycleState.onPagePause;
}
