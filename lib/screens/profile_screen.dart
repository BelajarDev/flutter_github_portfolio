import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../services/github_service.dart';
import '../models/github_user.dart';
import '../screens/repos_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final GithubService _githubService = GithubService();
  GithubUser? _user;
  bool _isLoading = true;
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _githubService.getUserData();
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _user = user;
      });
      _animationController.forward();
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1C2128),
      highlightColor: const Color(0xFF2D333B),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar shimmer
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 30),
            // Name shimmer
            Container(
              width: 200,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            // Username shimmer
            Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 30),
            // Bio shimmer
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1C2128).withOpacity(0.8),
            const Color(0xFF2D333B).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF30363D),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6E57E0),
                  const Color(0xFF9D8BFF),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8B949E),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF30363D), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6E57E0),
                  const Color(0xFF9D8BFF),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6E57E0), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFC9D1D9),
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.code,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 10),
            const Text('GitHub Portfolio'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadUserData,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.refresh, size: 22),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF0D1117),
              Color(0xFF0A0D14),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? _buildLoadingShimmer()
              : _errorMessage.isNotEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade900,
                                    Colors.red.shade600,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Connection Error',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                _errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF8B949E),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: _loadUserData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6E57E0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Retry Connection',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Profile Header
                            Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF161B22).withOpacity(0.8),
                                    const Color(0xFF0D1117).withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xFF30363D),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Avatar with gradient border
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF6E57E0),
                                          const Color(0xFF9D8BFF),
                                          Colors.purple,
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: CachedNetworkImage(
                                        imageUrl: _user!.avatarUrl,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            color: const Color(0xFF6E57E0),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Name and Username
                                  Text(
                                    _user!.name,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 26 : 32,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '@${_user!.login}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF8B949E),
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  // Bio
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF161B22),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      _user!.bio,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFC9D1D9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Stats Section - RESPONSIVE
                            if (isSmallScreen)
                              // Mobile Layout
                              Column(
                                children: [
                                  _buildMobileStatCard(
                                    'Repositories',
                                    _user!.publicRepos.toString(),
                                    Icons.folder,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildMobileStatCard(
                                    'Followers',
                                    _user!.followers.toString(),
                                    Icons.people,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildMobileStatCard(
                                    'Following',
                                    _user!.following.toString(),
                                    Icons.person_add,
                                  ),
                                ],
                              )
                            else
                              // Desktop/Tablet Layout
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.9,
                                children: [
                                  _buildStatCard(
                                    'Repositories',
                                    _user!.publicRepos.toString(),
                                    Icons.folder,
                                  ),
                                  _buildStatCard(
                                    'Followers',
                                    _user!.followers.toString(),
                                    Icons.people,
                                  ),
                                  _buildStatCard(
                                    'Following',
                                    _user!.following.toString(),
                                    Icons.person_add,
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),

                            // Info Section
                            Column(
                              children: [
                                _buildInfoRow(
                                    Icons.location_on, _user!.location),
                                const SizedBox(height: 10),
                                _buildInfoRow(Icons.business, _user!.company),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  Icons.link,
                                  _user!.blog.isNotEmpty
                                      ? _user!.blog
                                      : 'No website',
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),

                            // View Repositories Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReposScreen(
                                        username: _user!.login,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6E57E0),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.code, size: 22),
                                    SizedBox(width: 10),
                                    Text(
                                      'Explore Repositories',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Footer
                            Text(
                              _user!.joinDate,
                              style: const TextStyle(
                                color: Color(0xFF8B949E),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}

// PERHATIAN: Ada typo di class name, harusnya _ProfileScreenState bukan _HomeScreenState
// Ganti class name di atas dari _HomeScreenState menjadi _ProfileScreenState
