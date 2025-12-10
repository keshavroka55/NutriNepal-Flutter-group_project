import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UI/splashes/app_colors.dart';
import '../../UI/widgets/bottom_control_panel.dart';
import 'edit_food_screen.dart';
import 'food_api.dart';
import 'food_model.dart';
import 'food_quality_update.dart';

class FoodScreen2 extends StatefulWidget {
  const FoodScreen2({super.key});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen2> {
  List<Food> foods = [];
  bool loading = true;
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFoods();
  }

  Future<void> loadFoods() async {
    setState(() => loading = true);
    try {
      final foodApi = Provider.of<FoodApi>(context, listen: false);
      final result = await foodApi.searchFoods(q: searchQuery);
      setState(() => foods = result);
    } catch (e) {
      setState(() => foods = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load foods: $e'),
          backgroundColor: NutriColors.danger,
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  void searchFood(String query) {
    searchQuery = query;
    loadFoods();
  }

  void _clearSearch() {
    _searchController.clear();
    searchQuery = "";
    loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NutriColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: NutriColors.textPrimary,
        elevation: 0,
        title: const Text(
          "Food Database",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: NutriColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search foods...",
                        hintStyle: TextStyle(color: NutriColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onSubmitted: searchFood,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          searchFood("");
                        }
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: NutriColors.textSecondary),
                      onPressed: _clearSearch,
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),

          // Results Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Food Items",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: NutriColors.textPrimary,
                  ),
                ),
                Text(
                  "${foods.length} found",
                  style: TextStyle(
                    color: NutriColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Food List
          Expanded(
            child: loading
                ? const Center(
              child: CircularProgressIndicator(color: NutriColors.primary),
            )
                : foods.isEmpty
                ? _buildEmptyState()
                : _buildFoodList(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 1),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: NutriColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            searchQuery.isEmpty ? 'No Foods Available' : 'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: NutriColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isEmpty
                ? 'Food database appears to be empty'
                : 'Try searching with different keywords',
            style: TextStyle(
              color: NutriColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          if (searchQuery.isNotEmpty)
            ElevatedButton(
              onPressed: _clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: NutriColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear Search'),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return _buildFoodCard(food);
      },
    );
  }

  Widget _buildFoodCard(Food food) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditFoodScreen2(food: food),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: NutriColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getFoodIcon(food.category),
                  color: NutriColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Food Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.nameEn,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: NutriColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Fixed: Nutrient chips with Wrap to prevent overflow
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _buildNutrientChip(
                          '${food.caloriesKcal.toInt()} Cal',
                          NutriColors.accent,
                        ),
                        _buildNutrientChip(
                          '${food.proteinG.toStringAsFixed(1)}g P',
                          NutriColors.success,
                        ),
                        _buildNutrientChip(
                          '${food.fatG.toStringAsFixed(1)}g F',
                          NutriColors.danger,
                        ),
                        _buildNutrientChip(
                          '${food.carbsG.toStringAsFixed(1)}g C',
                          NutriColors.accentLight,
                        ),
                      ],
                    ),

                    if (food.category != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: NutriColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          food.category!,
                          style: TextStyle(
                            fontSize: 11,
                            color: NutriColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right,
                color: NutriColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getFoodIcon(String? category) {
    if (category == null) return Icons.restaurant;

    final cat = category.toLowerCase();
    if (cat.contains('fruit')) return Icons.apple;
    if (cat.contains('vegetable')) return Icons.eco;
    if (cat.contains('meat') || cat.contains('chicken')) return Icons.restaurant_menu;
    if (cat.contains('dairy') || cat.contains('milk')) return Icons.coffee;
    if (cat.contains('grain') || cat.contains('bread')) return Icons.bakery_dining;
    if (cat.contains('drink') || cat.contains('beverage')) return Icons.local_drink;
    return Icons.restaurant;
  }
}