import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/github_repo.dart';
import '../widgets/repo_card.dart';

class ReposScreen extends StatefulWidget {
  final String username;

  const ReposScreen({super.key, required this.username});

  @override
  State<ReposScreen> createState() => _ReposScreenState();
}

class _ReposScreenState extends State<ReposScreen> {
  final GithubService _githubService = GithubService();
  List<GithubRepo> _repos = [];
  List<GithubRepo> _filteredRepos = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  String _sortBy = 'updated';

  @override
  void initState() {
    super.initState();
    _loadRepos();
  }

  Future<void> _loadRepos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final repos = await _githubService.getUserRepos(sort: _sortBy);
      setState(() {
        _repos = repos;
        _filteredRepos = repos;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchRepos(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredRepos = _repos;
      } else {
        _filteredRepos = _repos.where((repo) {
          return repo.name.toLowerCase().contains(query.toLowerCase()) ||
              repo.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _changeSort(String sort) {
    setState(() {
      _sortBy = sort;
    });
    _loadRepos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s Repositories'),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeSort,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'updated',
                child: Text('Last Updated'),
              ),
              const PopupMenuItem(
                value: 'stars',
                child: Text('Most Stars'),
              ),
              const PopupMenuItem(
                value: 'forks',
                child: Text('Most Forks'),
              ),
              const PopupMenuItem(
                value: 'name',
                child: Text('Name (A-Z)'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchRepos,
              decoration: InputDecoration(
                hintText: 'Search repositories...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF161B22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredRepos.length} repositories',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  Chip(
                    label: Text('Search: "$_searchQuery"'),
                    backgroundColor: const Color(0xFF161B22),
                    labelStyle: const TextStyle(color: Colors.white),
                    deleteIconColor: Colors.white,
                    onDeleted: () => _searchRepos(''),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Repositories List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF6E57E0),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Loading repositories...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Failed to load repositories',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                _errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _loadRepos,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6E57E0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    : _filteredRepos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'No repositories found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  TextButton(
                                    onPressed: () => _searchRepos(''),
                                    child: const Text(
                                      'Clear search',
                                      style:
                                          TextStyle(color: Color(0xFF6E57E0)),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredRepos.length,
                            itemBuilder: (context, index) {
                              final repo = _filteredRepos[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: RepoCard(repo: repo),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
