class Pet {
  final int id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final double weight;
  final String? photoPath;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.weight,
    this.photoPath,
  });

  Pet copyWith({
    int? id,
    String? name,
    String? species,
    String? breed,
    int? age,
    double? weight,
    String? photoPath,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
