import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/station.dart';

class StationService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  StationService(this._firestore, this._firebaseAuth);

  // Get a stream of saved stations for the current user
  Stream<List<Station>> getSavedStations() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return Stream.value([]); // No user logged in, return empty list
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedStations')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Station.fromJson(doc.data());
      }).toList();
    });
  }

  // Add a station to the current user's saved stations
  Future<void> addStation(Station station) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedStations')
        .doc(station.stationuuid) // Use stationuuid as document ID
        .set({
          'stationuuid': station.stationuuid,
          'name': station.name,
          'url': station.url,
          'favicon': station.favicon,
          'tags': station.tags,
          'votes': station.votes,
          'clickcount': station.clickcount,
          'addedAt': FieldValue.serverTimestamp(), // Timestamp for when it was added
        });
  }

  // Remove a station from the current user's saved stations
  Future<void> removeStation(String stationuuid) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedStations')
        .doc(stationuuid)
        .delete();
  }

  // Check if a station is saved by the current user
  Future<bool> isStationSaved(String stationuuid) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return false;
    }

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedStations')
        .doc(stationuuid)
        .get();

    return doc.exists;
  }
}
