# Mood Waves

> Created By:

1. Wills Edgar - Lead Developer
2. Carson Godwin - Project Manager
3. Anna Burgess - Developer
4. Sam Huff - Developer
5. Taylor Morabito - Developer

## Prerequisites

- Get flutter installed on your machine. [Install Flutter](https://flutter.dev/docs/get-started/install)

## Building and Running the Project

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/UNCW-CSC-450/csc450-sp24-project-group-5.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get
```

**Step 3:**

Execute the following command to run the project:

```
flutter run
```

***
### Class tests for events, mood, and mood_info: 
- events_class_test.dart : tests construction of a MentalHealthEvent object and verifies the data in a list of MentalHealthEvent objects
- mood_class_test.dart : tests construction of a Mood object
- mood_info_class_test: tests construction of MoodInfo object which uses moods and verifies data in a list of MoodInfo

- To run the test(s), either use:
  - the Testing panel in the sidebar of VSCode or
  - run ``` flutter test ``` to run all test within the project or
  - run ``` flutter test test/[filename.dart] ``` to run indiviudal tests 
