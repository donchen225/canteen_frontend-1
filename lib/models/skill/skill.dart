import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Skill {
  final String name;
  final String description;
  final int price;
  final int duration;

  const Skill(
    this.name,
    this.description,
    this.price,
    this.duration,
  );

  Skill.fromMap(Map<dynamic, dynamic> data)
      : name = data['name'],
        description = data['description'],
        price = data['price'],
        duration = data['duration'];

  @override
  String toString() {
    return 'Skill { name: $name, description: $description, price: $price, duration: $duration }';
  }

  static Skill fromEntity(SkillEntity skill) {
    return Skill(
      skill.name,
      skill.description,
      skill.price,
      skill.duration,
    );
  }

  SkillEntity toEntity() {
    return SkillEntity(
      name,
      description,
      price,
      duration,
    );
  }
}
