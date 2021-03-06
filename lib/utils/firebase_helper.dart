import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/general_alert_dialog.dart';

class FirebaseHelper {
  addOrUpdateFirebaseContent(
    BuildContext context, {
    required String collectionId,
    required String whereId,
    required String whereValue,
    required Map<String, dynamic> map,
  }) async {
    try {
      GeneralAlertDialog().customLoadingDialog(context);

      final data = await getData(
        collectionId: collectionId,
        whereId: whereId,
        whereValue: whereValue,
      );

      if (data.docs.isEmpty) {
        await FirebaseFirestore.instance.collection(collectionId).add(map);
      } else {
        data.docs.first.reference.update(map);
        
      }

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (ex) {
      Navigator.pop(context);
      throw ex.toString();
    }
  }

  updateFirebaseContent(
    BuildContext context, {
    required String collectionId,
    required String whereId,
    required String whereValue,
    required Map<String, dynamic> map,
  }) async {
    try {
      GeneralAlertDialog().customLoadingDialog(context);

      final data = await getData(
        collectionId: collectionId,
        whereId: whereId,
        whereValue: whereValue,
      );
      data.docs.first.reference.update(map);

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (ex) {
      Navigator.pop(context);
      throw ex.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllData(
    BuildContext context, {
    required String collectionId,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final data = await firestore.collection(collectionId).get();

      return data;
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData({
    required String collectionId,
    required String whereId,
    required String whereValue,
    // required String docId,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;
      // firestore.collection(collectionId).doc(docId).update(data);

      final data = await firestore
          .collection(collectionId)
          .where(whereId, isEqualTo: whereValue)
          .get();

      return data;
    } catch (ex) {
      throw ex.toString();
    }
  }

  addData(
    BuildContext context, {
    required Map<String, dynamic> map,
    required String collectionId,
  }) async {
    try {
      // log("calling firebase");
      final docs =
          await FirebaseFirestore.instance.collection(collectionId).add(map);
      // log("document acheived");
      return docs.id;
    } catch (ex) {
      print(ex.toString());
    }
  }

  //update data
  updateData(
    BuildContext context, {
    required Map<String, dynamic> map,
    required String collectionId,
    required String docId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionId)
          .doc(docId)
          .update(map);
      // print("object");
    } catch (ex) {
      print(ex.toString());
    }
  }

  //delete data
   Future<void>deleteData(
    BuildContext context, {
    
    required String collectionId,
    required String docId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionId)
          .doc(docId)
          .delete();
      // print("object");
    } catch (ex) {
      print(ex.toString());
    }
  }
}
