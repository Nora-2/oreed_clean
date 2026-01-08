

class HomelayoutState {
  final int currentTabIndex;

  const HomelayoutState({this.currentTabIndex = 2});

  HomelayoutState copyWith({int? currentTabIndex}) {
    return HomelayoutState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}
