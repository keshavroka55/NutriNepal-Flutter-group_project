import 'package:flutter/material.dart';
import '../../../NutriNepal/services/api_service.dart';
import '../../../NutriNepal/widgets/bottom_control_panel.dart';
import '../models/food.dart';
import '../models/user_model.dart';

class FoodListScreen extends StatefulWidget {
  final User username;
  FoodListScreen({required this.username});
  // const FoodListScreen({super.key,required Food food});
  @override State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final _qCtrl = TextEditingController();
  List<Food> _foods = [];
  bool _loading = true;


  @override void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods([String? q]) async {
    setState(()=>_loading=true);
    try {
      final list = await ApiService.getFoods(q: q, page:1, limit:50);
      setState(()=> _foods = list);
    } catch (e) {
      // show error
    } finally { setState(()=>_loading=false); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Foods')),
    body: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(controller: _qCtrl, decoration: InputDecoration(hintText:'Search food')),
              ),
              IconButton(icon: Icon(Icons.search), onPressed: ()=> _loadFoods(_qCtrl.text.trim()))
            ],
          ),
        ),
        _loading
            ? Expanded(child: Center(child: CircularProgressIndicator()))
            : Expanded(
          child: ListView.separated(
            itemCount: _foods.length,
            separatorBuilder: (_,__) => Divider(),
            itemBuilder: (_, i) {
              final f = _foods[i];
              return ListTile(
                title: Text(f.nameEn),
                subtitle: Text('${f.calories} kcal • ${f.servingSize}${f.servingUnit}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FoodListScreen(username: widget.username), // change to your detail screen
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
    bottomNavigationBar: const BottomControlPanel(currentIndex: 0),
  );
  }
