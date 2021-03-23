import 'package:flutter/foundation.dart';

class SearchContactParams {
  final Uri nextPageURL;
  final String phoneNumber;

  SearchContactParams({
    @required this.nextPageURL,
    @required this.phoneNumber
  });
}