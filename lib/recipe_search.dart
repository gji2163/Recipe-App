import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_book_flutter/recipe.dart';
import 'package:recipe_book_flutter/api.dart';


class RecipeSearch {

    final String apiKey;

  RecipeSearch(this.apiKey);

  static Future<List<Recipe>> search(String query) async {
    final uri = Uri.parse("https://api.spoonacular.com/recipes/complexSearch?query=$query&apiKey=72c851fbf6f2401298b279edc43de7c6");
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to search recipes');
    }
  }
}
