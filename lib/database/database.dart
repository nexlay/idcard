import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:idcard/models/favorites_users.dart';
import 'package:idcard/models/search_user.dart';
import 'package:idcard/models/user.dart';

class DatabaseService {
  final String id;
  DatabaseService({this.id});
  //A reference to our collection of Users data in Firestore
  final CollectionReference usersCollection =
      Firestore.instance.collection('idcard_users');

  //Upload files to Firebase storage
  Future<void> uploadFile(File file, String filename) async {
    //A reference to our Firebase storage
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("images/$filename");
    //Put File into Firebase Storage
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    //If uploading is complete take download url and store it in String variable
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    String url = (await downloadUrl.ref.getDownloadURL());

    //Update url field in collection
    updateUserImageUrl(url);
  }

  //This function is insert document in collection
  Future setUserData(
      bool shared,
      int color,
      String token,
      String font,
      String image,
      String name,
      String job,
      String phone,
      String mail,
      String location,
      String link,
      String twitter,
      String facebook,
      String instagram,
      String github) async {
    return await usersCollection.document(id).setData({
      'shared': shared,
      'color': color,
      'token': token,
      'font': font,
      'image': image,
      'name': name,
      'job': job,
      'phone': phone,
      'mail': mail,
      'link': link,
      'location': location,
      'twitter': twitter,
      'facebook': facebook,
      'instagram': instagram,
      'github': github,
    });
  }

  //Add new collection of favorite users when favorite button clicked
  Future addFavoriteUsers(
      bool shared,
      bool favorite,
      int color,
      String token,
      String font,
      String image,
      String name,
      String job,
      String phone,
      String mail,
      String location,
      String link,
      String twitter,
      String facebook,
      String instagram,
      String github) async {
    return await usersCollection
        .document(id)
        .collection('favorites')
        .document(token)
        .setData({
      'shared': shared,
      'favorite': favorite,
      'color': color,
      'token': token,
      'font': font,
      'image': image,
      'name': name,
      'job': job,
      'phone': phone,
      'mail': mail,
      'link': link,
      'location': location,
      'twitter': twitter,
      'facebook': facebook,
      'instagram': instagram,
      'github': github,
    });
  }

  //Check if user is on favorite list or not
  Future<bool> checkExist(String token) async {
    bool exists = false;
    try {
      await usersCollection
          .document(id)
          .collection('favorites')
          .document(token)
          .get()
          .then((doc) {
        print(doc.exists);
        print(token);
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  //This function is update document with a new value privacy in collection (if true user give access to show his data to all)
  Future updateUserPrivacy(
    bool shared,
  ) async {
    return await usersCollection.document(id).updateData({
      'shared': shared,
    });
  }

  //This function is update document with a new value color in collection
  Future updateUserColor(
    int color,
  ) async {
    return await usersCollection.document(id).updateData({
      'color': color,
    });
  }

  //This function is update document with a new value color in collection
  Future updateUserImageUrl(
    String url,
  ) async {
    return await usersCollection.document(id).updateData({
      'image': url,
    });
  }

  //This function is update document with a new value color in collection
  Future updateUserFont(
    String font,
  ) async {
    return await usersCollection.document(id).updateData({
      'font': font,
    });
  }

  //This function is update document with a new user token in collection
  Future updateUserToken(
    String idToken,
  ) async {
    return await usersCollection.document(id).updateData({
      'token': idToken,
    });
  }

  //This function is update document in favorites collection
  Future updateFavoriteUser(bool favorite, String token) async {
    return await usersCollection
        .document(id)
        .collection('favorites')
        .document(token)
        .updateData({
      'favorite': true,
    });
  }

  Future deleteFavoriteUser(String token) async {
    return await usersCollection
        .document(id)
        .collection('favorites')
        .document(token)
        .delete();
  }

  List<SearchUsers> _listFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      if (doc.documentID == id) {
        return SearchUsers(
          shared: false,
          color: 4278228616,
          token: '',
          font: 'Pacifico',
          image: '',
          name: '',
          job: '',
          phone: '',
          mail: '',
          link: '',
          location: '',
          twitter: '',
          facebook: '',
          instagram: '',
          github: '',
        );
      } else
        return SearchUsers(
          shared: doc.data['shared'] ?? false,
          color: doc.data['color'] ?? 4278228616,
          token: doc.data['token'] ?? '',
          font: doc.data['font'] ?? 'Pacifico',
          image: doc.data['image'] ?? '',
          name: doc.data['name'] ?? '',
          job: doc.data['job'] ?? '',
          phone: doc.data['phone'] ?? '',
          mail: doc.data['mail'] ?? '',
          link: doc.data['link'] ?? '',
          location: doc.data['location'] ?? '',
          twitter: doc.data['twitter'] ?? '',
          facebook: doc.data['facebook'] ?? '',
          instagram: doc.data['instagram'] ?? '',
          github: doc.data['github'] ?? '',
        );
    }).toList();
  }

  List<FavoriteUsers> _favoriteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return FavoriteUsers(
        shared: doc.data['shared'] ?? false,
        favorite: doc.data['favorite'] ?? false,
        color: doc.data['color'] ?? 4278228616,
        token: doc.data['token'] ?? '',
        font: doc.data['font'] ?? 'Pacifico',
        image: doc.data['image'] ?? '',
        name: doc.data['name'] ?? '',
        job: doc.data['job'] ?? '',
        phone: doc.data['phone'] ?? '',
        mail: doc.data['mail'] ?? '',
        link: doc.data['link'] ?? '',
        location: doc.data['location'] ?? '',
        twitter: doc.data['twitter'] ?? '',
        facebook: doc.data['facebook'] ?? '',
        instagram: doc.data['instagram'] ?? '',
        github: doc.data['github'] ?? '',
      );
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserData(
      id: id,
      shared: documentSnapshot.data['shared'],
      token: documentSnapshot.data['token'],
      font: documentSnapshot.data['font'],
      color: documentSnapshot.data['color'],
      image: documentSnapshot.data['image'],
      name: documentSnapshot.data['name'],
      job: documentSnapshot.data['job'],
      phone: documentSnapshot.data['phone'],
      mail: documentSnapshot.data['mail'],
      link: documentSnapshot.data['link'],
      location: documentSnapshot.data['location'],
      twitter: documentSnapshot.data['twitter'],
      facebook: documentSnapshot.data['facebook'],
      instagram: documentSnapshot.data['instagram'],
      github: documentSnapshot.data['github'],
    );
  }

  //Get info stream
  Stream<List<SearchUsers>> get userInfo {
    return usersCollection.snapshots().map(_listFromSnapshot);
  }

  //Get favorite stream
  Stream<List<FavoriteUsers>> get favoriteUser {
    return usersCollection
        .document(id)
        .collection('favorites')
        .snapshots()
        .map(_favoriteListFromSnapshot);
  }

  //Get user doc stream
  Stream<UserData> get userData {
    return usersCollection.document(id).snapshots().map(_userDataFromSnapshot);
  }
}
