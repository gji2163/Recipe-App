class Recipe {
  final int id;
  final String title;
  final String imageURL;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.title,
    required this.imageURL,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    final ingredients = List<String>.from(map['extendedIngredients']
        .map((ingredient) => ingredient['originalString']));
    final instructions =
        List<String>.from(map['analyzedInstructions'][0]['steps']
            .map((step) => step['step']));
    return Recipe(
      id: map['id'],
      title: map['title'],
      imageURL: map['image'],
      ingredients: ingredients,
      instructions: instructions,
    );
  }
}


Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'ingredients': ingredients,
    'instructions': instructions,
    'isFavorite': isFavorite,
  };
}
