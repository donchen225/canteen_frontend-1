import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SkillEntity extends Equatable {
  final String name;
  final String description;
  final int price;
  final int duration;

  const SkillEntity(
    this.name,
    this.description,
    this.price,
    this.duration,
  );

  @override
  List<Object> get props => [
        name,
        description,
        price,
        duration,
      ];

  static SkillEntity fromSnapshot(DocumentSnapshot snap) {
    return SkillEntity(
      snap.data["name"],
      snap.data["description"],
      snap.data["price"],
      snap.data["duration"],
    );
  }

  static SkillEntity fromAlgoliaSnapshot(Map<dynamic, dynamic> data) {
    return SkillEntity(
      data['name'],
      data['description'],
      data['price'],
      data['duration'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "duration": duration,
    };
  }
}
