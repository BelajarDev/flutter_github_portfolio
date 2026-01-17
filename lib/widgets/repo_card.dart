import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/github_repo.dart';

class RepoCard extends StatelessWidget {
  final GithubRepo repo;

  const RepoCard({super.key, required this.repo});

  Color _getLanguageColor(String language) {
    final colors = {
      'Dart': const Color(0xFF00B4AB),
      'Java': const Color(0xFFB07219),
      'Kotlin': const Color(0xFFA97BFF),
      'Swift': const Color(0xFFF05138),
      'JavaScript': const Color(0xFFF7DF1E),
      'TypeScript': const Color(0xFF3178C6),
      'Python': const Color(0xFF3572A5),
      'C++': const Color(0xFFF34B7D),
      'C#': const Color(0xFF178600),
      'Go': const Color(0xFF00ADD8),
      'Rust': const Color(0xFFDEA584),
      'PHP': const Color(0xFF4F5D95),
      'Ruby': const Color(0xFF701516),
    };
    return colors[language] ?? const Color(0xFF8B949E);
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(repo.htmlUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchUrl,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF161B22).withOpacity(0.8),
                const Color(0xFF0D1117).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF30363D),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2128),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        repo.isPrivate ? Icons.lock : Icons.code,
                        color: const Color(0xFF6E57E0),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        repo.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (repo.isPrivate)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade900,
                              Colors.red.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Private',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                if (repo.description.isNotEmpty)
                  Text(
                    repo.description,
                    style: const TextStyle(
                      color: Color(0xFFC9D1D9),
                      fontSize: 15,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 16),

                // Stats row
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    // Language
                    if (repo.language.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2128),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getLanguageColor(repo.language),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              repo.language,
                              style: const TextStyle(
                                color: Color(0xFFC9D1D9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Stars
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2128),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.yellow.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            repo.stargazersCount.toString(),
                            style: const TextStyle(
                              color: Color(0xFFC9D1D9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Forks
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2128),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.fork_right_rounded,
                            color: Colors.blue.shade400,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            repo.forksCount.toString(),
                            style: const TextStyle(
                              color: Color(0xFFC9D1D9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Updated time
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2128),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: Colors.green.shade400,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            repo.lastUpdated,
                            style: const TextStyle(
                              color: Color(0xFFC9D1D9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // View on GitHub button
                if (repo.stargazersCount > 10 || repo.forksCount > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6E57E0).withOpacity(0.2),
                              const Color(0xFF9D8BFF).withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF6E57E0),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View on GitHub',
                              style: TextStyle(
                                color: Color(0xFF6E57E0),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF6E57E0),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
