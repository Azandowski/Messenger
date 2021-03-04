
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/**
 * * Holds response with pagination
 * ! T should have fromJson method
 */

class PaginatedResult <T> {
  final List<T> data;
  final PaginationData paginationData;

  PaginatedResult({
    this.data, 
    this.paginationData
  });

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T factory(Map<String, dynamic> data)
  ) {
    List jsonDataArray = (json['data'] ?? []) as List;
    return PaginatedResult(
      paginationData: PaginationData(
        nextPageUrl: json['next_page_url'] != null ?
           Uri.parse(json['next_page_url']) : null,
        isFirstPage: false
      ),
      data: jsonDataArray.map((e) => factory(e)).toList()
    );
  }
}


class PaginationData extends Equatable {
  final Uri nextPageUrl;
  final bool isFirstPage;

  PaginationData({
    @required this.nextPageUrl, 
    this.isFirstPage = true
  });

  factory PaginationData.defaultInit () {
    return PaginationData(
      nextPageUrl: null,
      isFirstPage: true
    );
  }

  factory PaginationData.fromJson(
    Map<String, dynamic> json
  ) {
    return PaginationData(
      nextPageUrl: json['next_page_url'],
    );
  }
  
  bool get hasNextPage {
    return nextPageUrl != null;
  }

  @override
  List<Object> get props => [nextPageUrl, isFirstPage];
}