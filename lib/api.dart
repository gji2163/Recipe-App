import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_book_flutter/recipe.dart';

class Api {
  static const String _baseUrl = 'https://api.spoonacular.com/recipes';
  static const String _apiKey = '72c851fbf6f2401298b279edc43de7c6';

  static Future<List<Recipe>> searchRecipes(String query) async {
    final url = Uri.parse('$_baseUrl/complexSearch?query=$query&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final recipes = data['results'] as List<dynamic>;
      return recipes.map((r) {
        final id = r['id'] as int;
        final title = r['title'] as String;
        final imageUrl = r['image'] as String;
        final ingredients = r['extendedIngredients'].map((i) => i['originalString'] as String).toList();
        final instructions = r['analyzedInstructions']
            .expand((i) => i['steps'].map((s) => s['step'] as String))
            .toList();
        return Recipe(id: id, title: title, imageUrl: imageUrl, ingredients: ingredients, instructions: instructions);
      }).toList();
    } else {
      throw Exception('Failed to search recipes');
    }
  }
}
