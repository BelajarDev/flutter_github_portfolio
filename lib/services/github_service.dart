import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_user.dart';
import '../models/github_repo.dart';
import '../utils/constants.dart';

class GithubService {
  static const String _baseUrl = 'https://api.github.com';
  static const Map<String, String> _headers = {
    'Accept': 'application/vnd.github.v3+json',
  };

  // Ganti dengan username GitHub Anda
  static const String _username = AppConstants.githubUsername;

  Future<GithubUser> getUserData() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/$_username'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return GithubUser.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<GithubRepo>> getUserRepos({
    String sort = 'updated',
    String direction = 'desc',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/users/$_username/repos?sort=$sort&direction=$direction&per_page=100'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => GithubRepo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load repos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<GithubRepo>> searchRepos(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search/repositories?q=user:$_username $query'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'];
        return items.map((json) => GithubRepo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search repos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
