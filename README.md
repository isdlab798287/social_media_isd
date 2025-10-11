# ButterFly

A responsive **Flutter social media application** for mobile and web, built with Firebase for real-time features and Cloudinary for media storage. This app supports authentication, chat, posts, likes, comments, follow/unfollow system, profile management, and theme switching.

---

## Table of Contents

- [Demo](#demo)  
- [Features](#features)  
- [Architecture](#architecture)  
- [Folder Structure](#folder-structure)  
- [Getting Started](#getting-started)  
- [Dependencies](#dependencies)  
- [Firebase Setup](#firebase-setup)  
- [Cloudinary Setup](#cloudinary-setup)  
- [Usage](#usage)  
- [Screenshots](#screenshots)  
- [Contributing](#contributing)  
- [License](#license)

---

## Features

- **Authentication**
  - Sign Up, Log In, Log Out  
  - Forgot Password / Reset Password
- **Profile & Social**
  - View & Edit Profile  
  - Follow / Unfollow Users  
  - View Followers / Following  
- **Posts & Feed**
  - Create, Edit, Delete Posts  
  - Upload Images (Cloudinary)  
  - View Newsfeed  
- **Social Interactions**
  - Like / Unlike Posts  
  - Add / Delete Comments  
- **Chat & Messaging**
  - 1:1 Chat  
  - Realtime messaging with Firebase  
  - Search Users to start a chat
- **Utilities**
  - Theme switching (Light / Dark Mode)  

---

## Architecture

The app is structured using **Feature-based modular architecture** and **Cubit (Bloc) state management**:

- **Features:** Auth, Chat, Home, Profile, Post, Settings, Storage  
- **Each feature contains:**  
  - `entities/` → variables and UI names  
  - `repos/` → function definitions and API methods  
  - `cubits/` → states and business logic  

- **Storage:**  
  - `StorageRepo` → interface for uploading and fetching images  
  - `CloudinaryStorageRepo` → implements Cloudinary integration  

- **Realtime Database & Auth:** Firebase Authentication, Firestore for posts, likes, comments, chats, and followers.

---

## Folder Structure

lib/
└─ features/
├─ auth/
│ ├─ entities/
│ ├─ repos/
│ └─ cubits/
├─ chat/
│ ├─ entities/
│ ├─ repos/
│ └─ cubits/
├─ home/
├─ profile/
├─ post/
├─ settings/
└─ storage/

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.x  
- Dart >= 3.x  
- Firebase project setup  
- Cloudinary account for image storage  

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/isd_app.git
cd isd_app
```

# Get dependencies
```bash
flutter pub get
```

# Run app (mobile)
```bash
flutter run
```

# Run app (web)
```bash
flutter run -d chrome
```

# Dependencies
Some key dependencies used in this app:

flutter_bloc → State management

firebase_auth → Firebase authentication

cloud_firestore → Firestore database

firebase_core → Firebase initialization

firebase_storage → Storing images (optional backup)

cloudinary_public → Cloudinary image uploads

equatable → For easier state comparisons

image_picker → Picking images from gallery/camera

responsive_framework → Responsive UI for web & mobile

(See pubspec.yaml for full list)

# Firebase Setup
Create a Firebase project at Firebase Console

Enable Authentication (Email/Password)

Create Firestore Database

Collections: users, posts, chat_rooms, messages, followers, etc.

Add google-services.json (Android) and GoogleService-Info.plist (iOS)

# Cloudinary Setup
Create a free account at Cloudinary

Create an upload preset

Replace placeholders in your app:

final cloudinary = CloudinaryPublic('YOUR_CLOUD_NAME', 'YOUR_UPLOAD_PRESET', cache: false);
# Usage
Home Page: Navigation Drawer with Home, Profile, Chat, Settings

Profile: View & Edit profile, see followers/following

Posts: Create post with text + image, like & comment

Chat: Realtime messaging with search

Settings: Switch between light and dark theme

