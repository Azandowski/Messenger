class Pagination {
  int limit = 10;
  int page = 1;
  bool finished = false;

  void next() {
    page++;
  }
}
