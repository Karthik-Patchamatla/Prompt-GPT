# PromptGPT - Flutter Application

**PromptGPT** is a Flutter application that includes a variety of screens and services designed for user authentication, chat functionality, and user interaction with Firebase. This README provides an overview of the project structure and the role of each file.

## Project Structure

The project is organized into the following structure:

- **promptgpt/**  
  - **lib/**  
    - **components/**  
      - `drawer.dart`  # Custom drawer widget  
      - `my_button.dart`  # Custom button widget  
      - `textfield.dart`  # Custom text field widget  
    - **pages/**  
      - `auth_page.dart`  # Authentication page for the app  
      - `chathistoryscreen.dart`  # Page to display the user's chat history  
      - `forgotpassword.dart`  # Page for password recovery  
      - `home_page.dart`  # Home page after login  
      - `intropage.dart`  # Introductory page for the app  
      - `loginpage.dart`  # User login page  
      - `registerpage.dart`  # User registration page  
    - **services/**  
      - `firestore_service.dart`  # Service to interact with Firestore


### Explanation:

- **lib/**: Contains all the main application code.
- **components/**: Custom reusable widgets like buttons, text fields, and the drawer.
- **pages/**: Screens of the app, including login, registration, and password recovery.
- **services/**: Contains services to interact with Firebase and Firestore.
- **main.dart**: The entry point where Firebase is initialized, and routes are set up.
- **assets/**: Folder for storing images and other app assets (like logos).

This directory structure ensures clarity and helps contributors understand the organization of the project easily.


## Getting Started

To use or further develop this app:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/PromptGPT.git

2. Navigate to the project directory:
   ```bash
   cd PromptGPT

3. Install dependencies: 
   ```bash
   flutter pub get

4. Run the app:
   ```bash
   flutter run
