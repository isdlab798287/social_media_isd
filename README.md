# isd_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


🌐 Social Media App

A full-featured Social Media Application named Butterfly built with Flutter and Firebase that allows users to connect, share, and engage through posts, likes, comments, and more.

📱 Features

✅ User Authentication

Sign up and log in using Firebase Authentication
Password reset and validation

✅ User Profile

Profile picture, bio, and personal details
View and edit profile
View other users’ profiles

✅ Posts

Create, edit, and delete posts
Upload images using Cloudinary API for optimized storage and fast loading
Like and comment on posts

✅ Search

Search for users by name or username
Quick access to profiles 

✅ Feed

See posts from users you follow
Auto-updating feed using Firebase Realtime Database

✅ Follow System

Follow and unfollow users
See follower and following counts

✅ Chat

Messaging option

✅ Dark/Light Theme

Theme toggle for better UX

🛠️ Tech Stack 

Technology:	Purpose
Flutter:	Frontend (cross-platform UI)
Firebase Authentication:	User sign-in/sign-up
Firebase Realtime Database / Firestore:	Data storage
Cloudinary : Image Hosting and Optimization
Bloc / Cubit / Provider:	State management
Git & GitHub:	Version control & collaboration

📂 Project Structure:

lib/
│
├── config/                # App configuration files (constants, routes, etc.)
│
├── features/              # All main features of the app
│   ├── auth/              # Login, signup, and authentication logic
│   ├── chat/              # Chat and messaging feature
│   ├── home/              # Home feed and main screen
│   ├── post/              # Post creation, upload, and display
│   ├── profile/           # User profile and edit profile screens
│   ├── search/            # Search users and posts
│   ├── settings/          # App settings (theme, preferences)
│   ├── storage/           # File/image storage and Firebase storage handling
│
├── services/              # Firebase, API, or helper service files
│
├── themes/                # App themes, colors, and styles
│
├── app.dart               # Root widget and app configuration
├── main.dart              # Main entry point of the Flutter app


📈 Future Improvements

Add Stories (like Instagram)
Push Notifications
Video Upload Support

👨‍💻 Contributors

Esha Saha (2107079)
Nuzhat Tasnim (2107082)
Afifa Sultana Offa (2107087)