# 🎬 MyMovie - Movie Discovery & Review Platform

> A feature-rich Flutter application for discovering movies, watching trailers, and sharing reviews using The Movie Database (TMDB) API.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-orange.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**🚀 [Live Demo](https://application-7d0e9.web.app/#/home)**

---

## 📱 Features

### 🎥 Movie Discovery
- **Browse Categories**: Popular, Top Rated, Trending, Upcoming, Now Playing
- **Advanced Search**: Real-time search with debouncing
- **Genre Filtering**: Discover movies by specific genres
- **Infinite Scroll**: Seamless pagination for browsing

### 🎬 Movie Details
- **Comprehensive Information**: Overview, release date, runtime, ratings
- **Cast & Crew**: View actor profiles with images, names, and character roles
- **Trailer Integration**: Watch official YouTube trailers in-app
- **Similar Movies**: Discover related content recommendations
- **User Reviews**: Read TMDB reviews and community comments

### 💬 Social Features
- **Comment System**: Share your thoughts on movies
- **Review Carousel**: Swipeable review cards with vertical scrolling
- **User Profiles**: Avatar display with personalized comments

### 🎨 UI/UX
- **Responsive Design**: Adaptive layouts for mobile, tablet, and web
- **Modern Interface**: Material Design 3 with custom theming
- **Dark Mode Support**: Elegant dark theme
- **Smooth Animations**: Page transitions and loading states
- **Image Caching**: Optimized performance with cached network images

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **GetX** | State management (MVC pattern) |
| **TMDB API** | Movie data source |
| **Carousel Slider** | Review carousel component |
| **Cached Network Image** | Image optimization |
| **HTTP** | API communication |
| **Shared Preferences** | Local data storage |

---
## 📂 Project Architecture

**Design Pattern**: MVC (Model-View-Controller) with GetX

### Directory Structure

- **lib/**
  - **common/** - Reusable UI components
    - widgets/movie_card/ - Movie card widget
  - **data/** - Data layer
    - api/ - API configuration
    - models/ - Data models (movie_model.dart, movie_details_model.dart)
    - enums/ - Enumerations
    - services/ - API services (tmdb_service.dart)
  - **features/** - Feature modules
    - home/ - Home screen
    - details/ - Movie details screen & controller
    - search/ - Search functionality
  - **routes/** - Navigation routing
  - **main.dart** - App entry point

### Key Components

| Layer | Description |
|-------|-------------|
| **Models** | Data structures for movies and details |
| **Services** | TMDB API communication layer |
| **Controllers** | Business logic with GetX state management |
| **Views** | UI screens and widgets |
| **Routes** | Navigation configuration |




