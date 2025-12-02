import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UI/widgets/bottom_control_panel.dart';
import 'edit_food_screen.dart';
import 'food_api.dart';
import 'food_model.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<Food> foods = [];
  bool loading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadFoods();
  }

  /// Load foods from API
  Future<void> loadFoods() async {
    setState(() => loading = true); // start spinner
    try {
      final foodApi = Provider.of<FoodApi>(context, listen: false);
      final result = await foodApi.searchFoods(q: searchQuery); // returns List<Food>
      setState(() => foods = result);
    } catch (e) {
      setState(() => foods = []); // empty list on error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load foods: $e')));
    } finally {
      setState(() => loading = false); // stop spinner
    }
  }

  /// Handle search
  void searchFood(String query) {
    searchQuery = query;
    loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foods"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: "Search food...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search)),
              onSubmitted: searchFood,
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : foods.isEmpty
          ? const Center(child: Text('No foods found'))
          : ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return ListTile(
            title: Text(food.nameEn),
            subtitle: Text("${food.caloriesKcal} kcal"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditFoodScreen(food: food),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 1),
    );
  }
}
