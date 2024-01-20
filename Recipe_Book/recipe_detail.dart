import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/recipe.dart';
import 'package:recipe_book_flutter/storage.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;

  RecipeDetail({required this.recipe});

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    Storage.getFavoriteRecipes().then((list) {
      setState(() {
        _isFavorite = list.any((r) => r.id == widget.recipe.id);
      });
    });
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        Storage.removeFavoriteRecipe(widget.recipe);
      } else {
        Storage.addFavoriteRecipe(widget.recipe);
      }
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(widget.recipe.imageURL),
            SizedBox(height: 16),
            Text('Ingredients', style: Theme.of(context).textTheme.headline6),
            ...widget.recipe.ingredients.map((i) => Text(i)),
            SizedBox(height: 16),
            Text('Instructions', style: Theme.of(context).textTheme.headline6),
            ...widget.recipe.instructions.asMap().entries.map((e) => ListTile(
                  leading: Text((e.key + 1).toString()),
                  title: Text(e.value),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
      ),
    );
  }
}
