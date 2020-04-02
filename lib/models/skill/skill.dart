import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Skill {
  final String id;
  final String name;
  final String description;
  final int price;

  const Skill(
    this.id,
    this.name,
    this.description,
    this.price,
  );

  Skill.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        name = data['name'],
        description = data['description'],
        price = data['price'];

  @override
  String toString() {
    return 'SKill { id: $id, name: $name, description: $description, price: $price }';
  }

  static Skill fromEntity(SkillEntity skill) {
    return Skill(
      skill.id,
      skill.name,
      skill.description,
      skill.price,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
    };
  }
}
