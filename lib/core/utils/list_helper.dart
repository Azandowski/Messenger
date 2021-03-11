extension AdvancedList<T> on List<T> {
  T get lastItem {
    if (this.length == 0) {
      return null;
    } else {
      return this.last;
    }
  }

  T getItemAt (int index) {
    if (this.length - 1 >= index && index >= 0) {
      return this[index];
    } else {
      return null;
    }
  }
}