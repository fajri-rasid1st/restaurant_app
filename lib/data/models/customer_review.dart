class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  /// Constructor untuk membuat objek CustomerReview dari bentuk map
  /// (hasil parsing json)
  factory CustomerReview.fromMap(Map<String, dynamic> customerReview) {
    return CustomerReview(
      name: customerReview['name'] ?? '',
      review: customerReview['review'] ?? '',
      date: customerReview['date'] ?? '',
    );
  }
}
