

import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class SearchEngingeDelegate {
  void startSearching({
    @required String text
  });
}

class SearchEngine {
  final SearchEngingeDelegate delegate;
  
  SearchEngine({
    @required this.delegate
  });


  Timer debounce;

  void onTextChanged (String newText) {
    if (debounce?.isActive ?? false) {
      debounce.cancel();
    }

    debounce = Timer(Duration(seconds: 2), () async {
      delegate.startSearching(text: newText);
    });
  }
}