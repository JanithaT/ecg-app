# ECG Monitoring System using Flutter

## Overview

This mobile application is designed to monitor and visualize ECG (Electrocardiogram) data. It connects to a Firebase database for data storage and communicates with an IoT device to collect ECG readings. The application provides real-time monitoring and visualization of ECG data, and also predict the arrthmia category using deep learning model.

## Purpose
Research - Cost-Effective ECG Machine Synchronized to Mobile Phone for Data Display and Analysis 

## Features

- Cross-platform mobile app developed with Flutter.
- Integration with Firebase for real-time data storage.
- Communication with an IoT device for ECG data collection.
- Real-time monitoring and visualization of ECG data.
- Data analytics using deep learning model.

## Requirements

- Flutter SDK [Link](https://flutter.dev/docs/get-started/install)
- Firebase account for database setup [Link](https://firebase.google.com/)
- IoT device for ECG data collection.
- Android or iOS device for testing the app.

## Installation

1. Clone the repository: `git clone [repository_url]`
2. Navigate to the project directory: `cd [project_directory]`
3. Install dependencies: `flutter pub get`

## Usage

1. Configure Firebase:
   - Create a Firebase project and set up a Realtime Database.
   - Update the Firebase configuration in the app (location: `lib/firebase/firebase_config.dart`).
   
2. Set up IoT Device:
   - Connect your IoT device to the app using the appropriate communication method (Wi-Fi).
   - Ensure the IoT device is sending ECG data to the app.

3. Run the app:
   - Connect your Android/iOS device or use an emulator.
   - Run the app using `flutter run`.

4. Explore the ECG monitoring features:
   - Add patient & Monitor real-time ECG data.
   - Predict the arrythmia category


