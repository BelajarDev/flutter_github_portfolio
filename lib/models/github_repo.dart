class GithubRepo {
  final int id;
  final String name;
  final String fullName;
  final String description;
  final String htmlUrl;
  final String language;
  final int stargazersCount;
  final int forksCount;
  final int watchersCount;
  final DateTime updatedAt;
  final bool isPrivate;

  GithubRepo({
    required this.id,
    required this.name,
    required this.fullName,
    required this.description,
    required this.htmlUrl,
    required this.language,
    required this.stargazersCount,
    required this.forksCount,
    required this.watchersCount,
    required this.updatedAt,
    required this.isPrivate,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      description: json['description'] ?? 'No description',
      htmlUrl: json['html_url'] ?? '',
      language: json['language'] ?? 'Not specified',
      stargazersCount: json['stargazers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      watchersCount: json['watchers_count'] ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      isPrivate: json['private'] ?? false,
    );
  }

  String get lastUpdated {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }
}
