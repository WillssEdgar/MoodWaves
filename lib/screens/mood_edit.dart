import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/mood_info.dart';

class MoodEdit extends StatefulWidget {
  const MoodEdit({super.key});

  @override
  State<MoodEdit> createState() => _MoodEditState();
}

class _MoodEditState extends State<MoodEdit> {
  DateTime today = DateTime.now();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late MoodInfo moodInfo = MoodInfo(DateFormat('yyyy-MM-dd').format(today),
      [Mood("No moods entered for this date", Colors.blueGrey.shade100)]);
  late Map<String, Color> moodColors = {};
  late List<TextEditingController> _titleControllers = [];

  void _initializeControllers() {
    _titleControllers = moodInfo.moodlist.map((mood) {
      return TextEditingController(text: mood.moodName);
    }).toList();
  }

  void _updateFirebaseMoodName(Mood mood, String newName, int index) async {
    // Find the mood document reference
    final moodDocumentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('moodEntries')
        .doc(moodInfo.date); // Assuming moodInfo.date is the document ID

    // Fetch the document snapshot
    final moodDocumentSnapshot = await moodDocumentReference.get();

    // Get the data from the snapshot
    final moodData = moodDocumentSnapshot.data();

    // Check if moodData is not null and contains the moodList
    if (moodData != null && moodData.containsKey('moodList')) {
      // Get the moodList from moodData
      List<dynamic> moodList = moodData['moodList'];
      if (newName == moodList[index]) {
        return;
      }

      // Ensure the index is within bounds
      if (index >= 0 && index < moodList.length) {
        // Update the mood name at the specified index in the array

        moodList[index] = newName;

        // Update the moodList in Firestore
        await moodDocumentReference.update({'moodList': moodList});
      }
    }
  }

  void _saveChangesToFirebase() {
    // Iterate over each mood and its corresponding text controller
    for (int i = 0; i < moodInfo.moodlist.length; i++) {
      final mood = moodInfo.moodlist[i];
      final newMoodName = _titleControllers[i].text;

      _updateFirebaseMoodName(mood, newMoodName, i);
    }
  }

  Future<void> fetchMoodEntry(DateTime selectedDay) async {
    if (userId.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('moodEntries')
          .where('id', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDay))
          .get();

      final List<String> moodList = [];

      for (var doc in querySnapshot.docs) {
        final moodEntry = doc.data();
        if (moodEntry.containsKey('moodList')) {
          final List<dynamic> moodListDynamic = moodEntry['moodList'];
          moodList.addAll(moodListDynamic.map((e) => e.toString()));
        }
      }
      List<Mood> moods;
      if (moodList.isNotEmpty) {
        moods = moodList.map((moodName) {
          Color moodColor = getColorForMoodName(moodName);
          return Mood(moodName, moodColor);
        }).toList();
      } else {
        moods = [
          Mood("No moods entered for this date", Colors.blueGrey.shade100)
        ];
      }
      setState(() {
        moodInfo =
            MoodInfo(DateFormat('yyyy-MM-dd').format(selectedDay), moods);
      });
    }
  }

  static const List<String> predefinedMoods = [
    'peaceful',
    'sad',
    'angry',
    'sick',
    'happy'
  ];

  // Function to validate entered mood
  String? validateMood(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!predefinedMoods.contains(value.toLowerCase())) {
        return 'Invalid mood. Please enter one of the predefined moods: ' +
            predefinedMoods.join(', ');
      }
    }
    return null; // Return null if validation passes
  }

  void _deleteMoodEntry(int index) async {
    // Show a confirmation dialog before deleting
    bool deleteConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Mood Entry'),
        content: Text('Are you sure you want to delete this mood entry?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Cancel deletion
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Confirm deletion
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );

    // Delete the mood entry if confirmed
    if (deleteConfirmed) {
      // Remove the mood entry from Firestore
      final moodDocumentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('moodEntries')
          .doc(moodInfo.date);
      final moodDocumentSnapshot = await moodDocumentReference.get();

      // Get the data from the snapshot
      final moodData = moodDocumentSnapshot.data();

      // Check if moodData is not null and contains the moodList
      if (moodData != null && moodData.containsKey('moodList')) {
        // Get the moodList from moodData
        List<dynamic> moodList = moodData['moodList'];

        moodList.removeAt(index);

        await moodDocumentReference.update({'moodList': moodList});

        // await moodDocumentReference.update({
        //   'moodList': FieldValue.arrayRemove([moodInfo.moodlist[index].moodName])
        // });
      }

      setState(() {
        moodInfo.moodlist.removeAt(index); // Remove the mood entry
        _titleControllers
            .removeAt(index); // Remove the corresponding text controller
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMoodEntry(today).then((_) {
      _initializeControllers();
    });
  }

  /// Maps mood names to corresponding colors.
  Color getColorForMoodName(String moodName) {
    // Here you can associate mood names with colors
    switch (moodName.toLowerCase()) {
      case 'peaceful':
        return Colors.greenAccent.shade400;
      case 'sad':
        return Colors.blue.shade400;
      case 'angry':
        return Colors.red.shade400;
      case 'sick':
        return Colors.deepPurple.shade300;
      case 'happy':
        return Colors.yellow.shade400;
      default:
        return Colors.blueGrey.shade100; // Default color for unknown mood names
    }
  }

  bool get allMoodsValid {
    // Check if all mood entries are valid
    for (var controller in _titleControllers) {
      if (validateMood(controller.text) != null) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Entry', style: theme.textTheme.titleLarge),
        actions: [
          Visibility(
            visible: allMoodsValid,
            child: IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  _saveChangesToFirebase();
                  Navigator.pop(context);
                }),
          ),
        ],
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the start
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Text(
                "Mood Entries for: " + DateFormat('yyyy-MM-dd').format(today),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: ListView(
                // Use ListView instead of ListView.builder
                shrinkWrap:
                    true, // Ensure ListView takes only the space it needs

                children: _titleControllers.asMap().entries.map((entry) {
                  final mood = moodInfo.moodlist[entry.key];
                  final errorText = validateMood(entry.value.text);

                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: SizedBox(
                        child: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(
                              hintText: "Enter title here",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              errorText: errorText),
                          onChanged: (text) => setState(() {}),
                        ),
                      ),
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: mood.moodColor,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteMoodEntry(entry.key);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
