// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'dart:convert';

ItemDataModel itemDatafromJson(String str) =>
    ItemDataModel.fromJson(json.decode(str) as Map<String, dynamic>);

class ItemDataModel {
  ItemDataModel({
    required this.isComplete,
    required this.userId,
    this.finishDateTime,
    this.startDateTime,
    required this.name,
    required this.id,
  });

  factory ItemDataModel.fromJson(Map<String, dynamic> json) => ItemDataModel(
        isComplete:
            json['isComplete'] == null ? false : json['isComplete'] == '1',
        id: json['id'] == null ? '0' : json['id'].toString(),
        userId: json['userId'] == null ? '0' : json['userId'].toString(),
        name: json['name'] == null ? '' : json['name'].toString(),
        startDateTime: json['startDateTime'].toString(),
        finishDateTime: json['finishDateTime'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'userId': userId,
        'startDateTime': startDateTime,
        'finishDateTime': finishDateTime,
        'isComplete': isComplete
      };

  final String? name;
  final String? id;
  final bool? isComplete;
  final String? userId;
  final String? startDateTime;
  final String? finishDateTime;
}
