extension AdvancedList<T> on List<T> {
  T get lastItem {
    if (this.length == 0) {
      return null;
    } else {
      return this.last;
    }
  }
}