# Offline First Demo

- [Offline First Demo](#offline-first-demo)
  - [1. App Description](#1-app-description)
  - [2. Environment](#2-environment)
  - [3. How to run project](#3-how-to-run-project)
    - [a. Install Flutter and Dart](#a-install-flutter-and-dart)
    - [b. Set Up an Integrated Development Environment (IDE)](#b-set-up-an-integrated-development-environment-ide)
    - [c. Connect a Device or Emulator](#c-connect-a-device-or-emulator)
    - [d. Run the Flutter App](#d-run-the-flutter-app)
  - [4. Project Structure](#4-project-structure)
  - [5. Folder Structure](#5-folder-structure)
  - [6. Isar package](#6-isar-package)
  - [7. Local DB Service](#7-local-db-service)
      - [Constructor](#constructor)
      - [Methods](#methods)
      - [getData](#getdata)
      - [initWatcher](#initwatcher)
      - [saveData](#savedata)
      - [removeData](#removedata)
      - [Error Handling](#error-handling)
  - [8. State Management](#8-state-management)
  - [9. Bloc + Freezed usage](#9-bloc--freezed-usage)

## 1. App Description

This app is designed to provide offline functionality, allowing users to access and interact with its features even when they are not connected to the internet. Speaking of features, currently there are only news and details of those news.

Offline-first applications are designed to provide a consistent user experience regardless of network connectivity. This means that the application is built with the assumption that network connection is an enhancement, not a necessity.

Key features of offline-first apps include:

* Data Persistence: Offline-first apps store data locally on the device. This allows users to access and interact with their data even when they're offline.

* Data Synchronization: When the device is online, the app synchronizes the local data with the server. This ensures that the data is up-to-date across all devices.

* Responsive UI: The UI of an offline-first app is responsive even when the device is offline. The app doesn't rely on a network connection to respond to user interactions.

* Network Awareness: Offline-first apps are aware of the network state. They can adapt their behavior based on whether the device is online or offline.

Offline-first apps provide a better user experience in areas with poor or no network connectivity. They also allow users to continue working during network outages, making them a good choice for mobile apps where network conditions can be unpredictable.

The flow of this application like this:
1. If it is the first time that users opens the app it shows progress indicator in home view.
2. If it is not the first time users sees the data that comes from local database.
3. Then we initialize watcher for local database. If there is any change in local db, it will update the UI according to changed data.
4. Then we send request for data to network.
5. If this request is successful, then we remove the data in local db and update it with the new data.
6. If this request is failure, then we continue on showing the old local db data.

## 2. Environment

Flutter SDK programming language is used.

- Flutter (Channel stable, 3.19.2, on macOS 14.3.1 23D60 darwin-arm64, locale en-TR)
  - Flutter version 3.19.2 on channel stable
  - Dart version 3.3.0
  - DevTools version 2.31.1
- Android toolchain (Android SDK version 34.0.0)
  - Platform android-34, build-tools 34.0.0
  - Java version OpenJDK Runtime Environment
- Xcode (version 15.2)
  - CocoaPods (version 1.15.2)
- Google Chrome
- Android Studio (version 2023.1)
  - Java version OpenJDK Runtime Environment
- VS Code (version 1.87.0)
  - Flutter extension version 3.82.0

## 3. How to run project

### a. Install Flutter and Dart

First, make sure you have Flutter and Dart installed on your computer. You can download and install them from the official Flutter website: [Flutter Installation Guide](https://docs.flutter.dev/get-started/install).

### b. Set Up an Integrated Development Environment (IDE)

Choose an IDE for Flutter development. Two popular options are:
**Android Studio**: It comes with built-in Flutter support and is the official IDE recommended by Google for Flutter development.
**Visual Studio Code (VS Code)**: You can install the Flutter and Dart plugins to get Flutter development support in VS Code.

### c. Connect a Device or Emulator

You'll need a physical device (e.g., a smartphone or tablet) connected to your computer or an emulator (Android Virtual Device or iOS Simulator) set up to run your Flutter app. Ensure that your device is in developer mode and connected via USB if using a physical device.

### d. Run the Flutter App

You will need an api key from https://newsapi.org/ for the API calls. And you need to run project like this:

```sh
flutter run --dart-define API-KEY=your_api_key
```

## 4. Project Structure

It has been used Clean Architecture and Domain-Driven Design (DDD) principles in the project.

This structure promotes separation of concerns and allows you to develop the app in a modular and testable way. You can expand upon this structure based on your project's specific requirements and complexity. Additionally, make sure to adhere to the SOLID principles and DDD concepts as you design and implement your Flutter app to ensure maintainability and scalability. For further information please check:

- [The Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [A Guided Tour of Clean Architecture](https://www.freecodecamp.org/news/a-quick-introduction-to-clean-architecture-990c014448d2/)
- [Domain-Driven Design Quickly PDF](https://www.infoq.com/minibooks/domain-driven-design-quickly/)
- [Reso Coder Clean Architecture Tutorials](https://resocoder.com/flutter-clean-architecture-tdd/)

## 5. Folder Structure

Here's a basic project structure outline that combines Clean Architecture and Domain-Driven Design (DDD) principles approaches:

    offline-first/
      └── lib/
           ├── core/
           │     ├── constant/
           │     ├── dependency_injection/
           │     ├── exception/
           │     ├── enums/
           │     └── service/
           └── feature/
                 └── one_of_feature/
                       ├── core/
                       ├── data/
                       ├── domain/
                       └── presentation/


- **lib**: This is the main application code directory.
  - **core**: It contains common structures and datas used throughout the application.
  - **feature**: It contains modules of the project.
    - **core**: It contains feature related files and files that must not get into other folders.
    - **data**: It contains data sources, repositories implementations, and data models for data persistence.
    - **domain**: It contains domain entities, repositories, and value objects as per DDD principles.
    - **presentation**: It contains user interface components, including pages and widgets.

## 6. Isar package

The Isar package is a high-performance NoSQL database for Flutter and Dart applications. It is designed to be fast, efficient, and easy to use. Here are some key features:

* Type Safety: Isar is a type-safe database, meaning that it enforces data type constraints.

* Zero-Copy: Isar uses a zero-copy architecture which makes it incredibly fast.

* ACID Transactions: Isar supports ACID (Atomicity, Consistency, Isolation, Durability) transactions, ensuring data integrity.

* Queries: Isar supports complex queries, allowing you to filter and sort your data as needed.

* Cross-Platform: Isar works on Android, iOS, macOS, Linux, Windows, and in the browser.

* Object Watchers: Isar can automatically notify your app when objects are changed.

In the context of the project, Isar is used in the LocalDBService class to perform operations on the local database.

## 7. Local DB Service

LocalDBService is a class that implements the ILocalDBService interface. It provides methods for interacting with a local database using the Isar package.

#### Constructor
```dart
const LocalDBService(this._isar);
```

The constructor takes an instance of Isar as a parameter. This instance is used for all database operations.

#### Methods
#### getData
```dart
Future<List<E>> getData<E>();
```

This method retrieves all data of type E from the local database. It returns a Future that completes with a List<E>.

#### initWatcher
```dart
void initWatcher<E>(void Function(List<E>) callback);
```
This method initializes a watcher on the collection of type E in the local database. Whenever data in the collection changes, the provided callback function is called with the updated data.

#### saveData
```dart
Future<void> saveData<E>(List<E> list);
```
This method saves a list of data of type E to the local database. It returns a Future that completes when the operation is finished.

#### removeData
```dart
Future<void> removeData<E>();
```
This method removes all data of type E from the local database. It returns a Future that completes when the operation is finished.

#### Error Handling
All methods in LocalDBService are wrapped in a try-catch block. If an error occurs during a database operation, the error is rethrown to be handled by the caller.

## 8. State Management

Bloc and Cubit are state management patterns commonly used in Flutter applications.

**Bloc:** Bloc is a state management pattern that separates the business logic from the UI. It stands for Business Logic Component. Bloc consists of three main components: the event, the state, and the logic. The event represents user actions or system events that trigger a state change. The state represents the current state of the application. The logic processes the events and updates the state accordingly. Bloc provides a clear separation of concerns and helps in writing testable and maintainable code.

**Cubit:** Cubit is a simplified version of Bloc. Cubit is a lightweight state management solution that focuses on simplicity and ease of use. It follows a similar pattern as Bloc, but with fewer boilerplate code. Cubit has a single input and output, which makes it suitable for simple state management scenarios. It is recommended to use Cubit when the state management requirements are not complex.

Both Bloc and Cubit are based on the concept of reactive programming, where the UI reacts to changes in the state. They provide a predictable and scalable way to manage the state of your Flutter application.

## 9. Bloc + Freezed usage

Bloc and Freezed can be used together to manage state in a Flutter application.

Bloc is a state management library that uses the concept of events to trigger state changes. It separates the business logic from the UI, making the code more maintainable and testable.

Freezed is a code generation library that helps in creating immutable classes and unions (sealed classes) in Dart. It simplifies the process of creating immutable objects and provides a clean, simple way to define immutable data models.

When used together, Bloc and Freezed offer several benefits:

Immutable State: Freezed provides a way to create immutable state classes, which can help prevent unwanted state changes.

Reduced Boilerplate: Freezed generates the boilerplate code required for immutable classes, reducing the amount of code you need to write.

Clear State Transitions: By using Freezed with Bloc, you can define clear, type-safe state transitions. This makes it easier to understand how different events affect the state of your application.

Enhanced Testability: The combination of Bloc and Freezed makes your code more testable. You can easily test the different states of your application and how different events lead to different states.

Here's an example of how you can use Bloc and Freezed together:
```dart
@freezed
abstract class MyState with _$MyState {
    const factory MyState.initial() = _Initial;
    const factory MyState.loading() = _Loading;
    const factory MyState.loaded(List<Data> data) = _Loaded;
}

class MyCubit extends Cubit<MyState> {
    MyCubit() : super(MyState.initial());

    void loadData() async {
        emit(MyState.loading());
        final data = await fetchData();
        emit(MyState.loaded(data));
    }
}
```

In this example, the MyState class is defined using Freezed, and the MyCubit class uses this state class to manage its state. The loadData method in MyCubit emits different states based on the progress of the data loading operation.
