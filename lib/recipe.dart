class Recipe {
  final String id;
  final String title;
  final String summary;
  final String imageURL;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageURL,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      imageURL: json['image'],
      ingredients: List<String>.from(json['extendedIngredients']
          .map((ingredient) => ingredient['original'] as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'imageURL': imageURL,
      'ingredients': ingredients,
    };
  }

  List<String> getIngredients() {
    return ingredients;
  }
}
