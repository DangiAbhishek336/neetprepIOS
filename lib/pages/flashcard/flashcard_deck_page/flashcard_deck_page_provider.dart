import 'dart:developer';

import 'package:flutter/material.dart';

class FlashcardDeckProvider extends ChangeNotifier {
  List<dynamic> myList = [];
  int index = 0;


  void populateList(List<dynamic> temp){
    myList.addAll(temp);
    log(myList.toString());
    notifyListeners();
  }

  void addItem(dynamic item) {
     myList.add(item);
    notifyListeners();
  }

  void deleteItem(int index) {
    if (index >= 0 && index < myList.length) {
      myList.removeAt(index);
      notifyListeners();
    }
  }
  void updateIndex(int value){
    index=value;
    notifyListeners();

  }
}

