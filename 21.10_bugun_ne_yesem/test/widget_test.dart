import 'package:flutter_test/flutter_test.dart';
import 'package:bugun_ne_yesem/core/models/chef_recipe_model.dart';
import 'package:bugun_ne_yesem/core/services/database_service.dart';

void main() {
  test('Inventory add and remove test', () async {
    final db = DatabaseService();

    final initialList = await db.getInventory('test_user');
    expect(initialList.contains('Limon'), isTrue);

    await db.removeInventoryIngredient('test_user', 'Limon');
    final afterRemoval = await db.getInventory('test_user');
    expect(afterRemoval.contains('Limon'), isFalse);

    await db.addInventoryIngredient('test_user', 'Avokado');
    final afterAdd = await db.getInventory('test_user');
    expect(afterAdd.contains('Avokado'), isTrue);
  });

  test('Chef recipe add and stream test', () async {
    final db = DatabaseService();

    final initialChefRecipes = await db.getChefRecipes('default_user');
    final initialCount = initialChefRecipes.length;

    final newRecipe = ChefRecipeModel(
      id: 'test_chef_123',
      userId: 'default_user',
      name: 'Özel Soslu Tavuklu Penne',
      ingredients: ['Tavuk Göğsü', 'Makarna', 'Sarımsak'],
      calories: 450,
      steps: 'Tavukları soteleyin ve makarnayla karıştırın.',
      createdAt: DateTime.now(),
    );

    await db.addChefRecipe(newRecipe);

    final updatedRecipes = await db.getChefRecipes('default_user');
    expect(updatedRecipes.length, equals(initialCount + 1));
    expect(updatedRecipes.any((r) => r.name == 'Özel Soslu Tavuklu Penne'), isTrue);

    // Also check that it's added to the general recipe pool with Masterchef category
    final allRecipes = await db.getRecipes();
    expect(allRecipes.any((r) => r.name == 'Özel Soslu Tavuklu Penne' && r.category == 'Masterchef'), isTrue);
  });
}
