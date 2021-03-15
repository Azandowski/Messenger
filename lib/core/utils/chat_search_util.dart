import 'package:flutter/foundation.dart';

class ChatSearchUtil {
  int _count = 5;
  int _half = 2;
  
  String getSearchResult ({
    @required String queryText,
    @required String inputText
  }) {
    List<String> arr = inputText.split(" ");
    String output = "";
      
    if (arr.length <= _count) {
      output = arr.join(" ");
    } else {
      var index = arr.indexWhere((e) => e.toLowerCase().contains(queryText.toLowerCase()));
      if (index != -1) {
        if (index >= _count - 1) {
          if (index + _half >= arr.length - 1) {
            output =  _getItemsRange(arr, index - _half, arr.length - 1).join(" "); 
          } else {
            output = _getItemsRange(arr, index - _half, index + _half).join(" "); 
          }   
        } else { 
          output = _getItemsRange(arr, 0, _count - 1).join(" ");
        } 
      } else {
        output = inputText;
      }
    }

    return output;
  } 
  
  // Get Items Range
  List<String> _getItemsRange (List<String> arr, int fromIndex, int endIndex) {
    List<String> arr2 = [];
    for (int i = fromIndex; i <= endIndex; i++) {
      arr2.add(arr[i]);
    }

    return arr2;
  }
}