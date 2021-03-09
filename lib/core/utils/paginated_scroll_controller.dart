import 'package:flutter/cupertino.dart';

class PaginatedScrollController extends ScrollController {
  bool get isPaginated {
    var triggerFetchMoreSize = 0.7 * position.maxScrollExtent;
    return offset > triggerFetchMoreSize;
  }
}