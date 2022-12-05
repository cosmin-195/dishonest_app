import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Lie {
  String? id;
  String title;
  String text;
  String truth;
  LieSeverity severity;
  List<Lie> relatedTo = List.empty(growable: true);
  List<String> heardBy = List.empty(growable: true);

  Lie(
    this.id,
    this.title,
    this.text,
    this.truth,
    this.severity,
  );
}

enum LieSeverity { mild, normal, severe }

class LieRepository with ChangeNotifier {
  int current = 0;
  Map<String, Lie> map = Map.fromEntries([
    MapEntry(
        "l1",
        Lie("l1", "title 1", "some sample text", "the truth",
            LieSeverity.severe)),
    MapEntry(
        "l2",
        Lie("l2", "title 2", "another sample text", "truth 2",
            LieSeverity.mild))
  ]);

  List<Lie> findAll() {
    return List.of(map.values);
  }

  void addLie(Lie lie) {
    lie.id = "lie$current";
    current++;
    map[lie.id!] = lie;
    notifyListeners();
  }

  void deleteLie(String id) {
    map.remove(id);
    notifyListeners();
  }

  void updateLie(Lie newLie) {
    map.update(newLie.id!, (value) => value = newLie);
    notifyListeners();
  }

  Lie getLie(String id) {
    if (map.containsKey(id)) {
      return map[id]!;
    }
    throw Exception("Invalid map access");
  }
}
