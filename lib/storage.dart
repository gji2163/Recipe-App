import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_book_flutter/recipe.dart';

class Storage {
  static const String _key = 'FAVORITE_RECIPES';

  static Future<List<Recipe>> getFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) {
      return [];
    } else {
      final data = jsonDecode(json) as List<dynamic>;
      return data.map((r) {
        final id = r['id'] as int;
        final title = r['title'] as String;
        final imageURL = r['imageURL'] as String;
        final ingredients = List<String>.from(r['ingredients'] as List);
        final instructions = List<String>.from(r['instructions'] as List);
        return Recipe(id: id, title: title, imageURL: imageURL, ingredients: ingredients, instructions: instructions);
      }).toList();
    }
  }

  static Future<void> addFavoriteRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) {
      prefs.setString(_key, jsonEncode([recipe.toJson()]));
    } else {
      final data = jsonDecode(json) as List<dynamic>;
      data.add(recipe.toJson());
      prefs.setString(_key, jsonEncode(data));
    }
  }

  static Future<void> removeFavoriteRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json != null) {
      final data = jsonDecode(json) as List<dynamic>;
      final index = data.indexWhere((r) => r['id'] == recipe.id);
      if (index >= 0) {
        data.removeAt(index);
        prefs.setString(_key, jsonEncode(data));
      }
    }
  }
}
