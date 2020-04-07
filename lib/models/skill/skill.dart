import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Skill {
  final String name;
  final String description;
  final int price;

  const Skill(
    this.name,
    this.description,
    this.price,
  );

  Skill.fromMap(Map<dynamic, dynamic> data)
      : name = data['name'],
        description = data['description'],
        price = data['price'];

  @override
  String toString() {
    return 'Skill { name: $name, description: $description, price: $price }';
  }

  static Skill fromEntity(SkillEntity skill) {
    return Skill(
      skill.name,
      skill.description,
      skill.price,
    );
  }

  SkillEntity toEntity() {
    return SkillEntity(
      name,
      description,
      price,
    );
  }
}
