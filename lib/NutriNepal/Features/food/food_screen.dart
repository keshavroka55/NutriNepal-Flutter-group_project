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

  Future<void> loadFoods() async {
    setState(() => loading = true);
    try {
      final foodApi = Provider.of<FoodApi>(context, listen: false);
      final result = await foodApi.searchFoods(q: searchQuery);
      setState(() => foods = result);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false); // spinner stops
    }
  }

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
