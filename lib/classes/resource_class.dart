import 'package:cloud_firestore/cloud_firestore.dart';

/// Defines a resource for the resources page, contains the variables inside
/// 
/// Returns a resource object/widget
class Resource {
  // for students find help in the real world

  final String resourceName;
  final num resourceNum;
  final String resourceURL;
  final String resourceDesc;

  Resource(
      {required this.resourceName,
      required this.resourceNum,
      required this.resourceURL,
      required this.resourceDesc});
}

/// Retrieves each item from the Firestore database's resources file. In event of failure, returns dummy data.
Future <List<Resource>> firestoreFunct() async {

  List<Resource> functioningList = [];

  try {

    QuerySnapshot instanceShot = await FirebaseFirestore.instance.collection('resources').get();

    instanceShot.docs.forEach((doc) {

      functioningList.add(Resource(
        resourceName: doc['name'],
        resourceNum: doc['num'],
        resourceDesc: doc['desc'],
        resourceURL: doc['url'],
      ));

    });

  }

  catch (e) {

    return functioningList = [
      Resource(
      resourceName: "National Mental Health Helpline",
      resourceNum: 2341414,
      resourceDesc: "Available 24/7 for mental health support.",
      resourceURL: "tel:1-800-662-HELP"),
  Resource(
      resourceName: "Crisis Text Line",
      resourceNum: 00002,
      resourceDesc: "Text HOME to 741741 for free, 24/7 crisis support.",
      resourceURL: "sms:741741"),
  Resource(
      resourceName: "Campus Counseling Center",
      resourceNum: 00003,
      resourceDesc: "Professional counseling services for students.",
      resourceURL: "https://yourcollege.edu/counseling"),
  Resource(
      resourceName: "Sleep Foundation",
      resourceNum: 00004,
      resourceDesc: "Definitive website for sleep improvement",
      resourceURL: "https://www.sleepfoundation.org"),
  Resource(
      resourceName: "UNCW Counseling Center",
      resourceNum: 00005,
      resourceDesc: "Schedule appointments with helpful staff",
      resourceURL: "https://uncw.edu/seahawk-life/health-wellness/counseling/")

    ];
  }

  return functioningList;

}


/// Void function, intended to move a future List<Resource> to a normal List<Resource>
void futureWaiter() async {

  List<Resource> returningList = await firestoreFunct();

  var sampleLists = returningList;
  print(sampleLists);
}

var sampleLists = [
      Resource(
      resourceName: "National Mental Health Helpline",
      resourceNum: 2341414,
      resourceDesc: "Available 24/7 for mental health support.",
      resourceURL: "tel:1-800-662-HELP"),
  Resource(
      resourceName: "Crisis Text Line",
      resourceNum: 00002,
      resourceDesc: "Text HOME to 741741 for free, 24/7 crisis support.",
      resourceURL: "sms:741741"),
  Resource(
      resourceName: "Campus Counseling Center",
      resourceNum: 00003,
      resourceDesc: "Professional counseling services for students.",
      resourceURL: "https://yourcollege.edu/counseling"),
  Resource(
      resourceName: "Sleep Foundation",
      resourceNum: 00004,
      resourceDesc: "Definitive website for sleep improvement",
      resourceURL: "https://www.sleepfoundation.org"),
  Resource(
      resourceName: "UNCW Counseling Center",
      resourceNum: 00005,
      resourceDesc: "Schedule appointments with helpful staff",
      resourceURL: "https://uncw.edu/seahawk-life/health-wellness/counseling/")

    ];
