import 'package:brewcrew/models/brew.dart';
import 'package:brewcrew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection = Firestore.instance.collection("brews");

  List<Brew> _getListOfBrews(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        uid: doc.documentID,
        name: doc.data['name'] ?? '',
        sugars: doc.data['sugars'] ?? '0',
        strength: doc.data['strength'] ?? 0,
        cups: doc.data['cups'] ?? 0
      );
    })
    .toList();
  }

  UserData _getUserData(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
      cups: snapshot.data['cups']
    );
  }

  // get user data stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_getUserData);
  }

  // get brews stream
  Stream<List<Brew>> get brew {
    return brewCollection.snapshots().map(_getListOfBrews);
  }

  Future updateUserData(String name, String sugars, int strength, int cups) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
      'cups' : cups
    });
  }
}