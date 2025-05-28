class Article {
  const Article({
    this.titleVal,
    this.authorVal,
    this.descriptionVal,
    this.contentVal,
    this.urlVal,
    this.urlToImageVal,
    this.publishedAtVal,
    this.sourceVal,
  });

  final String? titleVal;
  final String? authorVal;
  final String? descriptionVal;
  final String? contentVal;
  final String? urlVal;
  final String? urlToImageVal;
  final DateTime? publishedAtVal;
  final String? sourceVal;
}
