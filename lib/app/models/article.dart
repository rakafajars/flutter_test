class Article {
  final String title;
  final String description;
  final String url;
  final String? imageUrl;
  final String source;
  final DateTime? publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
    required this.source,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'],
      source: json['source']?['name'] ?? 'Unknown',
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
    );
  }

  String get timeAgo {
    if (publishedAt == null) return '';
    final difference = DateTime.now().difference(publishedAt!);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }
}
