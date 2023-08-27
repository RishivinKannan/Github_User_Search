# GitHub User Search App

A Flutter app that allows users to search for GitHub users and view their basic information. The app utilizes the GitHub REST API to retrieve user data based on the search query and provides a clean and user-friendly interface. Users can also toggle between dark and light themes.

## Features

- Search for GitHub users by username.
- View basic information about users:
  - Username
  - Profile picture
  - Number of followers
  - Number of repositories
  - Bio (if available)
- Toggle between dark and light themes.


## Getting Started

1. Clone this repository:
git clone https://github.com/yourusername/github-user-search-app.git

2. Change to the project directory:
cd github-user-search-app

3. Install the required dependencies:
flutter pub get

4. Run the app:
flutter run

## Configuration
## Splash Screen
This app uses a splash screen. You can customize the splash screen image and settings by editing the flutter_native_splash.yaml file in the project root.

## Dark and Light Themes
The app supports both dark and light themes. Users can toggle between themes in the app's settings.

## API Configuration
The app uses the GitHub REST API to fetch user data. Ensure that you have internet connectivity and that the API endpoints are accessible.

## Libraries and Packages Used
dio: For making HTTP requests to the GitHub API.
provider: For state management and theme toggling.
flutter_native_splash: For configuring the splash screen.


## Acknowledgments
Flutter: For the wonderful Flutter framework.
GitHub REST API: For providing user data.
Dio: For making HTTP requests.
Provider: For state management.
flutter_native_splash: For configuring the splash screen.
Feel free to contribute or open issues if you have any suggestions or encounter any problems!



