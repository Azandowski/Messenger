import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PaginatedScrollController extends ScrollController {
  
  bool isReversed = false;

  PaginatedScrollController({ this.isReversed = false });
  
  bool get isPaginated {
    if (isReversed) {
      return offset < 100;
    } else {
      var triggerFetchMoreSize = 0.7 * position.maxScrollExtent;
      return offset > triggerFetchMoreSize;
    }
  }

  bool get isReverslyPaginated {
    if (!isReversed) {
      return offset < 100;
    } else {
      var triggerFetchMoreSize = 0.7 * position.maxScrollExtent;
      return offset > triggerFetchMoreSize;
    }
  }
}
