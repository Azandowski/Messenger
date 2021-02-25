
/**
 * * Holds response with pagination
 * ! T should have fromJson method
 */

class PaginatedResult <T> {
  final List<T> data;
  final Uri nextPageUrl;

  PaginatedResult({
    this.data, 
    this.nextPageUrl
  });

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T factory(Map<String, dynamic> data)
  ) {
    List jsonDataArray = (json['data'] ?? []) as List;
    return PaginatedResult(
      nextPageUrl: json['next_page_url'],
      data: jsonDataArray.map((e) => factory(e)).toList()
    );
  }

  // * * Getters

  bool get hasSecondPage {
    return nextPageUrl != null;
  }
}
