class GithubUser {
  final String login;
  final String avatarUrl;
  final String name;
  final String bio;
  final String location;
  final String blog;
  final int publicRepos;
  final int followers;
  final int following;
  final String htmlUrl;
  final String company;
  final DateTime createdAt;

  GithubUser({
    required this.login,
    required this.avatarUrl,
    required this.name,
    required this.bio,
    required this.location,
    required this.blog,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.htmlUrl,
    required this.company,
    required this.createdAt,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      login: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      name: json['name'] ?? json['login'] ?? '',
      bio: json['bio'] ?? 'No bio available',
      location: json['location'] ?? 'Location not set',
      blog: json['blog'] ?? '',
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      htmlUrl: json['html_url'] ?? '',
      company: json['company'] ?? 'No company',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  String get joinDate {
    return 'Joined ${createdAt.year}';
  }
}
