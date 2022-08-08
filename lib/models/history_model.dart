import 'dart:convert';

class HistoryModel {
  final int? id;
  final String userinput, answer;
  HistoryModel({this.id, required this.userinput, required this.answer});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userinput': userinput,
      'answer': answer,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id']?.toInt() ?? 0,
      userinput: map['userinput'] ?? '',
      answer: map['answer'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) =>
      HistoryModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each histroy when using the print statement.
  @override
  String toString() =>
      'History(id: $id, userinput: $userinput, answer: $answer)';
}
