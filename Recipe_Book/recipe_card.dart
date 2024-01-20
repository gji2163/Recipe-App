import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/recipe', arguments: recipe);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: recipe.imageURL != null
                  ? Image.network(recipe.imageURL!, fit: BoxFit.cover)
                  : Container(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title, style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 8.0),
                  Text(recipe.summary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
