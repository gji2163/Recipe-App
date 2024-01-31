import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/recipe_card.dart';
import 'package:recipe_book_flutter/recipe.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;

  RecipeList({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return RecipeCard(recipe: recipes[index]);
      },
    );
  }
}
