# MatchMate (Matrimonial Card Interface)

## Overview
A SwiftUI app that displays matrimonial match cards using RandomUser API. Users can Accept/Decline and the app persists choices locally using Core Data, supports offline mode, and syncs when online.

## Features
- Fetches profiles from https://randomuser.me/api/
- Card-based UI with Accept/Decline
- Core Data persistence & offline mode
- Network monitoring and sync queue

## Tech stack
- Swift 5, SwiftUI
- Core Data
- URLSession
- SDWebImageSwiftUI
- iOS 15+

## Run
1. Open `MatchMate.xcodeproj`
2. Build & run on iOS 15+ simulator
3. Press Refresh to fetch profiles

## Project structure
- `Models/` - data models and API mapping
- `ViewModels/` - MVVM view models
- `Views/` - SwiftUI views
- `Persistence/` - Core Data stack
- `Networking/` - network layer

## Known limitations
- RandomUser API is read-only — sync to server is simulated.
