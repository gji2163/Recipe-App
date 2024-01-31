import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/recipe.dart';
import 'package:recipe_book_flutter/recipe_card.dart';
import 'package:recipe_book_flutter/recipe_list.dart';
import 'package:recipe_book_flutter/recipe_search.dart';
import 'package:recipe_book_flutter/storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Recipe Book'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _searchQuery = "";
  List<Recipe> _searchResults = [];
  List<Recipe> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  void _loadFavoriteRecipes() async {
    final favorites = await Storage.getFavoriteRecipes();
    setState(() {
      _favoriteRecipes = favorites;
    });
  }

  void _searchRecipes(String query) async {
    final results = await RecipeSearch.search(query);
    setState(() {
      _searchQuery = query;
      _searchResults = results;
    });
  }

  void _toggleFavoriteRecipe(Recipe recipe) async {
    setState(() {
      if (_favoriteRecipes.contains(recipe)) {
        _favoriteRecipes.remove(recipe);
      } else {
        _favoriteRecipes.add(recipe);
      }
      Storage.saveFavoriteRecipes(_favoriteRecipes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeList(
                    title: "Favorite Recipes",
                    recipes: _favoriteRecipes,
                    onToggleFavorite: _toggleFavoriteRecipe,
                  ),
                ),
              );
              _loadFavoriteRecipes();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch(
                context: context,
                delegate: RecipeSearchDelegate(),
              );
              if (query != null) {
                _searchRecipes(query);
              }
            },
          ),
        ],
      ),
      body: _searchQuery.isNotEmpty
          ? RecipeList(
              title: "Search Results",
              recipes: _searchResults,
              onToggleFavorite: _toggleFavoriteRecipe,
            )
          : Center(
              child: Text(
                "Use the search icon to find recipes!",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
    );
  }
}
