import '../database_helper.dart';
import '../../../models/article.dart';

class ArticleDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertArticle(Article article, {String? category}) async {
    final db = await _dbHelper.database;
    return await db.insert('articles', {
      'title': article.title,
      'description': article.description,
      'url': article.url,
      'imageUrl': article.imageUrl,
      'source': article.source,
      'publishedAt': article.publishedAt?.toIso8601String(),
      'category': category ?? 'general',
    });
  }

  Future<void> insertArticles(
    List<Article> articles, {
    String? category,
  }) async {
    final db = await _dbHelper.database;
    final batch = db.batch();

    await deleteArticlesByCategory(category ?? 'general');

    for (final article in articles) {
      batch.insert('articles', {
        'title': article.title,
        'description': article.description,
        'url': article.url,
        'imageUrl': article.imageUrl,
        'source': article.source,
        'publishedAt': article.publishedAt?.toIso8601String(),
        'category': category ?? 'general',
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<Article>> getArticlesByCategory(String category) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'articles',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'publishedAt DESC',
    );

    return maps.map((map) => _articleFromMap(map)).toList();
  }

  Future<List<Article>> getAllArticles() async {
    final db = await _dbHelper.database;
    final maps = await db.query('articles', orderBy: 'publishedAt DESC');
    return maps.map((map) => _articleFromMap(map)).toList();
  }

  Future<int> deleteArticlesByCategory(String category) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'articles',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> deleteAllArticles() async {
    final db = await _dbHelper.database;
    return await db.delete('articles');
  }

  Article _articleFromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      imageUrl: map['imageUrl'],
      source: map['source'] ?? '',
      publishedAt: map['publishedAt'] != null
          ? DateTime.tryParse(map['publishedAt'])
          : null,
    );
  }
}
