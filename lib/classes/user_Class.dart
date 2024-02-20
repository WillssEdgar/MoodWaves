// This file contains the user class
// This class is used to store the user data


class User{
  String? name;
  String? email;
  String? uid;
  
  User({this.name, this.email,required this.uid});

  

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    email = map['email'];
    uid = map['uid'];
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, uid: $uid}';
  }
}

var sampleUsers = [
  User(name: "John", email: "john@example.com", uid: "32jnfjkn2ksfw"),
  User(name: "Jane", email: "jane@example.com", uid: "4325rfdawr23f32d"),
  User(name: "Jannet", email: "jannet@example.com", uid: "e3fhjiuh43ignis23r"),
];

