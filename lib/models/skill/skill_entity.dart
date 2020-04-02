import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SkillEntity extends Equatable {
  final String name;
  final String description;
  final int price;

  const SkillEntity(
    this.name,
    this.description,
    this.price,
  );

  @override
  List<Object> get props => [
        name,
        description,
        price,
      ];

  static SkillEntity fromSnapshot(DocumentSnapshot snap) {
    return SkillEntity(
      snap.data["name"],
      snap.data["description"],
      snap.data["price"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "description": description,
      "price": price,
    };
  }
}
