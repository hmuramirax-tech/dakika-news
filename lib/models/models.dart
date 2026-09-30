/// Data models for DAKIKA.
/// Maps directly to Supabase tables.

class Source {
  final String id;
  final String name;
  final String url;
  final String? rssFeedUrl;
  final String language;
  final double credibilityScore;
  final bool isActive;

  const Source({
    required this.id,
    required this.name,
    required this.url,
    this.rssFeedUrl,
    required this.language,
    required this.credibilityScore,
    required this.isActive,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        rssFeedUrl: json['rss_feed_url'],
        language: json['language'],
        credibilityScore: (json['credibility_score'] as num).toDouble(),
        isActive: json['is_active'],
      );
}

class Category {
  final String id;
  final String name;
  final String nameEn;
  final String? nameRw;
  final String? nameSw;
  final String? icon;
  final String? color;
  final bool isActive;

  const Category({
    required this.id,
    required this.name,
    required this.nameEn,
    this.nameRw,
    this.nameSw,
    this.icon,
    this.color,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        nameEn: json['name_en'],
        nameRw: json['name_rw'],
        nameSw: json['name_sw'],
        icon: json['icon'],
        color: json['color'],
        isActive: json['is_active'],
      );

  String get displayName => nameEn;
}

class Article {
  final String id;
  final String? sourceId;
  final String title;
  final String? summary;
  final String? content;
  final String url;
  final String? imageUrl;
  final String? categoryId;
  final String language;
  final double? confidenceScore;
  final String status;
  final DateTime? publishedAt;
  final DateTime ingestedAt;

  // Joined fields
  final String? sourceName;
  final String? categoryName;

  const Article({
    required this.id,
    this.sourceId,
    required this.title,
    this.summary,
    this.content,
    required this.url,
    this.imageUrl,
    this.categoryId,
    required this.language,
    this.confidenceScore,
    required this.status,
    this.publishedAt,
    required this.ingestedAt,
    this.sourceName,
    this.categoryName,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'],
        sourceId: json['source_id'],
        title: json['title'],
        summary: json['summary'],
        content: json['content'],
        url: json['url'],
        imageUrl: json['image_url'],
        categoryId: json['category_id'],
        language: json['language'],
        confidenceScore: json['confidence_score'] != null
            ? (json['confidence_score'] as num).toDouble()
            : null,
        status: json['status'],
        publishedAt: json['published_at'] != null
            ? DateTime.parse(json['published_at'])
            : null,
        ingestedAt: DateTime.parse(json['ingested_at']),
        sourceName: json['source_name'],
        categoryName: json['category_name'],
      );

  String get readingTime {
    final wordCount = (summary ?? content ?? '').split(' ').length;
    final minutes = (wordCount / 200).ceil();
    return '${minutes < 1 ? 1 : minutes} min';
  }

  String get timeAgo {
    if (publishedAt == null) return '';
    final diff = DateTime.now().difference(publishedAt!);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}

class Digest {
  final String id;
  final DateTime date;
  final String period;
  final String? title;
  final List<String> storyIds;
  final DateTime createdAt;

  const Digest({
    required this.id,
    required this.date,
    required this.period,
    this.title,
    required this.storyIds,
    required this.createdAt,
  });

  factory Digest.fromJson(Map<String, dynamic> json) => Digest(
        id: json['id'],
        date: DateTime.parse(json['date']),
        period: json['period'],
        title: json['title'],
        storyIds: List<String>.from(json['story_ids'] ?? []),
        createdAt: DateTime.parse(json['created_at']),
      );
}

class Profile {
  final String id;
  final String? phone;
  final String? displayName;
  final String? avatarUrl;
  final String language;
  final String subscriptionTier;
  final String displayDensity;
  final bool dataSaver;
  final bool notificationsEnabled;

  const Profile({
    required this.id,
    this.phone,
    this.displayName,
    this.avatarUrl,
    required this.language,
    required this.subscriptionTier,
    required this.displayDensity,
    required this.dataSaver,
    required this.notificationsEnabled,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'],
        phone: json['phone'],
        displayName: json['display_name'],
        avatarUrl: json['avatar_url'],
        language: json['language'],
        subscriptionTier: json['subscription_tier'],
        displayDensity: json['display_density'],
        dataSaver: json['data_saver'],
        notificationsEnabled: json['notifications_enabled'],
      );
}
