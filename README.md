# 📝 **REPOSITORY SETUP - GitHub Portfolio App**

## 📌 **NAMA REPOSITORY:**

```
github-portfolio-flutter
```

**Alasan:** Simple, descriptive, SEO-friendly untuk "Flutter GitHub portfolio"

---

## 📝 **DESKRIPSI REPOSITORY:**

```markdown
🚀 A beautiful Flutter app to showcase your GitHub profile & repositories in style.

✨ Features:
• GitHub profile with stats, bio, and info
• Repository list with search & sorting
• Dark mode with gradient UI
• Real-time data from GitHub API
• Responsive design for all devices

🛠️ Built with Flutter, Dart, and GitHub REST API.
```

---

## 📖 **FILE: `README.md`** (SINGKAT & LENGKAP)

````markdown
# GitHub Portfolio Flutter App

A beautiful mobile application built with Flutter to showcase your GitHub profile and repositories with a modern dark theme.

![Flutter](https://img.shields.io/badge/Flutter-3.16-blue)
![Dart](https://img.shields.io/badge/Dart-3.0-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)

## ✨ Features

- **GitHub Profile Display** - Avatar, bio, stats, and information
- **Repository Browser** - View all repositories with search and sorting
- **Dark Modern UI** - Gradient backgrounds and glassmorphism effects
- **Real-time Data** - Fetches live data from GitHub API
- **Responsive Design** - Works on phones and tablets

## 📸 Screenshots

| Profile Screen                                  | Repositories                                  |
| ----------------------------------------------- | --------------------------------------------- |
| <img src="screenshots/profile.png" width="300"> | <img src="screenshots/repos.png" width="300"> |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Android Studio / VS Code
- GitHub account

### Installation

1. Clone the repository

```bash
git clone https://github.com/yourusername/github-portfolio-flutter.git
```
````

2. Navigate to project directory

```bash
cd github-portfolio-flutter
```

3. Update your GitHub username
   - Open `lib/utils/constants.dart`
   - Change `githubUsername` to your GitHub username

4. Install dependencies

```bash
flutter pub get
```

5. Run the app

```bash
flutter run
```

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point
├── models/               # Data models (User, Repository)
├── services/            # API service (GitHubService)
├── screens/             # UI screens (Profile, Repos)
├── widgets/             # Reusable widgets
└── utils/               # Constants and helpers
```

## 📦 Dependencies

- `http` - For API calls
- `cached_network_image` - For image caching
- `url_launcher` - For opening GitHub links
- `shimmer` - For loading animations
