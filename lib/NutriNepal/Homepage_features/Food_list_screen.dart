import 'package:flutter/material.dart';
import '../models/food.dart';
import '../services/api_service.dart';
import '../widgets/bottom_control_panel.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final _qCtrl = TextEditingController();
  List<Food> _foods = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods([String? q]) async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getFoods(q: q, page: 1, limit: 50);
      setState(() => _foods = list);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
    appBar: AppBar(title: const Text('Foods')),
    body: Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _qCtrl,
              decoration:
              const InputDecoration(hintText: 'Search food...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _loadFoods(_qCtrl.text.trim()),
          ),
        ]),
      ),
      _loading
          ? const Expanded(child: Center(child: CircularProgressIndicator()))
          : Expanded(
        child: ListView.separated(
          itemCount: _foods.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final f = _foods[i];
            return ListTile(
              title: Text(f.nameEn),
              subtitle: Text(
                  '${f.calories} kcal • ${f.servingSize}${f.servingUnit}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FoodListScreen(),
                ),
              ),
            );
          },
        ),
      ),
    ]),
    bottomNavigationBar: Padding(padding: const EdgeInsets.all(8.0),
    child: BottomControlPanel(currentIndex: 0),),
    // const BottomControlPanel(currentIndex: 0), // 👈 active index
  );
}
