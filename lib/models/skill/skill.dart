import 'package:canteen_frontend/models/skill/skill_entity.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:meta/meta.dart';

@immutable
class Skill {
  final String name;
  final String description;
  final int price;
  final int duration;
  final SkillType type;

  const Skill(
    this.name,
    this.description,
    this.price,
    this.duration,
    this.type,
  );

  Skill.fromMap(Map<dynamic, dynamic> data, SkillType type)
      : name = data['name'],
        description = data['description'],
        price = data['price'],
        duration = data['duration'],
        type = type;

  @override
  String toString() {
    return 'Skill { name: $name, description: $description, price: $price, duration: $duration, type: $type }';
  }

  static Skill fromEntity(SkillEntity skill, SkillType type) {
    return Skill(
      skill.name,
      skill.description,
      skill.price,
      skill.duration,
      type,
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
