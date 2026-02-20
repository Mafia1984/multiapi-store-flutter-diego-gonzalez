
class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  Character({required this.id, required this.name, required this.status, required this.species, required this.image});

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json['id'] as int,
        name: (json['name'] ?? '').toString(),
        status: (json['status'] ?? '').toString(),
        species: (json['species'] ?? '').toString(),
        image: (json['image'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'species': species,
        'image': image,
      };
}
