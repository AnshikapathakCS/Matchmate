# MatchMate

A simple SwiftUI matrimonial-style match app. Fetches profiles from
[randomuser.me](https://randomuser.me), lets the user accept or decline each
match, saves the result locally, and works offline by showing cached profiles.

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/de6d395f-4bc3-4b09-a05e-da17d60c1bda" width="260" alt="Match list" />
  <img src="https://github.com/user-attachments/assets/a020ca57-bef8-488e-a36a-7debdd6bf1eb" width="260" alt="Accept and decline states" />
  <img src="https://github.com/user-attachments/assets/cad2c774-710e-4aad-bd2f-90157101ae26" width="260" alt="Offline banner" />
</p>

## Features

- List of match cards with photo, name, age, and location
- Accept / Decline buttons; status persists across launches
- Offline support — cached profiles load instantly, refresh when online
- Pull to refresh, loading and error states

## Tech

- SwiftUI + MVVM (with a Repository layer)
- `URLSession` + `async/await`
- Core Data for persistence
- `NWPathMonitor` for connectivity
- No third-party libraries

## How to run

1. Open `Matchmate/Matchmate.xcodeproj` in Xcode 16+.
2. Select the `Matchmate` scheme.
3. Run on an iOS 17+ simulator or device.
