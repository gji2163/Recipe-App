import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecipeSearchScreen(),
    );
  }
}

class RecipeSearchScreen extends StatefulWidget {
  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  String _searchTerm = '';
  List<Recipe> _searchResults = [];

  void _searchRecipes(String searchTerm) async {
    final response = await http.get(
      Uri.parse('https://api.spoonacular.com/recipes/complexSearch?query=$searchTerm&apiKey=<YOUR_API_KEY>&number=10'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _searchResults = (responseData['results'] as List)
            .map((recipeData) => Recipe.fromMap(recipeData))
            .toList();
      });
    } else {
      print('Failed to load search results');
    }
  }

  void _navigateToRecipeDetails(Recipe recipe) async {
    final isFavorite = await _isRecipeFavorite(recipe.id);

    final updatedRecipe = Recipe(
      id: recipe.id,
      name: recipe.name,
      imageUrl: recipe.imageUrl,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      isFavorite: isFavorite,
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetailsScreen(recipe: updatedRecipe)),
    );

    if (result == true) {
      _saveRecipeToFavorites(updatedRecipe);
    } else if (result == false) {
      _removeRecipeFromFavorites(updatedRecipe);
    }
  }

  Future<bool> _isRecipeFavorite(int recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('recipe_$recipeId') ?? false;
  }

  Future<void> _saveRecipeToFavorites(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('recipe_${recipe.id}', true);
  }

  Future<void> _removeRecipeFromFavorites(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('recipe_${recipe.id}', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for recipes',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              onSubmitted: (value) {
                _searchRecipes(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final recipe = _searchResults[index];
                return ListTile(
                  leading: Image.network(recipe.imageUrl),
                  title: Text(recipe.name),
                  onTap: () {
                    _navigateToRecipeDetails(recipe);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton
