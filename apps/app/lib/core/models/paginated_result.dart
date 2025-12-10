class PaginatedResult<T> {
  final List<T> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}

extension PaginatedResultX<T> on PaginatedResult<T> {
  PaginatedResult<R> map<R>(R Function(T item) mapper) {
    return PaginatedResult<R>(
      items: items.map(mapper).toList(growable: false),
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}