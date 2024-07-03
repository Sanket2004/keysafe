# KeySafe

Welcome to KeySafe! This README will help you understand how to set up, run, and contribute to the KeySafe project. KeySafe is a secure and efficient password manager app built with Flutter and Firebase.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features

- Secure authentication with Firebase
- Store and manage passwords securely
- Biometric authentication for added security
- User-friendly interface with responsive design
- Edit profile information
- Tag-based password filtering
- Copy username and password functionality
- Update profile option
- Logout functionality

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase account: [Create a Firebase project](https://firebase.google.com/)

### Installation

1. **Clone the repository**

    ```sh
    git clone https://github.com/Sanket2004/keysafe.git
    cd keysafe
    ```

2. **Install dependencies**

    ```sh
    flutter pub get
    ```

3. **Set up Firebase**

    - Go to the [Firebase Console](https://console.firebase.google.com/)
    - Create a new project (or use an existing one)
    - Add an Android/iOS app to your Firebase project and download the `google-services.json` or `GoogleService-Info.plist` file
    - Place the `google-services.json` file in `android/app` directory and `GoogleService-Info.plist` file in `ios/Runner` directory
    - Enable Email/Password sign-in method in the Firebase Authentication section

4. **Run the app**

    ```sh
    flutter run
    ```

## Usage

### Authentication

- **Login:** Users can log in using their email and password.
- **Biometric Authentication:** Users can enable biometric authentication for quick and secure access.

### Password Management

- **Add Password:** Users can add new passwords with details like website, username, and password.
- **View Password:** Password details are protected and can be viewed after authentication.
- **Copy Username/Password:** Users can copy the username or password to the clipboard.

### Profile Management

- **View Profile:** Users can view their profile information.
- **Edit Profile:** Users can update their profile details. Fields become editable when the edit button is pressed.

### Tag-based Filtering

- Users can filter passwords based on predefined tags like Google, Facebook, etc.

### Logout

- Users can log out, which will redirect them to the login screen.

## Contributing

We welcome contributions to enhance KeySafe. To contribute:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Open a Pull Request

Please make sure to update tests as appropriate.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Thank you for using KeySafe! If you have any questions or feedback, feel free to open an issue on GitHub. Happy coding!
