import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../API/api_client.dart';
import '../../UI/splashes/app_colors.dart';
import '../logs/logs_api.dart';
import 'food_model.dart';

class EditFoodScreen2 extends StatefulWidget {
  final Food food;
  const EditFoodScreen2({super.key, required this.food});

  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen2> {
  double quantity = 100;
  bool saving = false;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = '100';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> saveLog() async {
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Quantity must be greater than 0'),
          backgroundColor: NutriColors.danger,
        ),
      );
      return;
    }

    setState(() => saving = true);

    try {
      final logsApi = Provider.of<LogsApi>(context, listen: false);
      final apiClient = Provider.of<ApiClient>(context, listen: false);

      debugPrint('Adding log: ${widget.food.nameEn}, Quantity: $quantity ${widget.food.unit}');

      await logsApi.addLog(
        foodId: widget.food.id,
        quantity: quantity,
        unit: widget.food.unit,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Food added to log successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: NutriColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint('addLog error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add log: $e'),
            backgroundColor: NutriColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final calculatedCalories = (widget.food.caloriesKcal * quantity / 100).toStringAsFixed(0);
    final calculatedProtein = (widget.food.proteinG * quantity / 100).toStringAsFixed(1);
    final calculatedFat = (widget.food.fatG * quantity / 100).toStringAsFixed(1);
    final calculatedCarbs = (widget.food.carbsG * quantity / 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: NutriColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: NutriColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Add to Log',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: NutriColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.restaurant,
                            color: NutriColors.primary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.food.nameEn,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: NutriColors.textPrimary,
                                ),
                              ),
                              if (widget.food.category != null) ...[
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: NutriColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.food.category!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: NutriColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Nutrition Info per 100g
                    Text(
                      'Nutrition per 100g',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: NutriColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNutritionItem(
                          label: 'Calories',
                          value: '${widget.food.caloriesKcal}',
                          unit: 'Cal',
                          color: NutriColors.accent,
                        ),
                        _buildNutritionItem(
                          label: 'Protein',
                          value: '${widget.food.proteinG}',
                          unit: 'g',
                          color: NutriColors.success,
                        ),
                        _buildNutritionItem(
                          label: 'Fat',
                          value: '${widget.food.fatG}',
                          unit: 'g',
                          color: NutriColors.danger,
                        ),
                        _buildNutritionItem(
                          label: 'Carbs',
                          value: '${widget.food.carbsG}',
                          unit: 'g',
                          color: NutriColors.accentLight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Quantity Input
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: NutriColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Unit Selection
                    Text(
                      'Unit: ${widget.food.unit}',
                      style: TextStyle(
                        color: NutriColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quantity Input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter quantity',
                                hintStyle: TextStyle(color: NutriColors.textSecondary),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              ),
                              onChanged: (value) {
                                final parsed = double.tryParse(value) ?? 100;
                                setState(() => quantity = parsed);
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              widget.food.unit,
                              style: TextStyle(
                                color: NutriColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick Quantity Buttons
                    const SizedBox(height: 16),
                    Text(
                      'Quick select:',
                      style: TextStyle(
                        color: NutriColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [50, 100, 150, 200, 250].map((value) {
                        return ElevatedButton(
                          onPressed: () {
                            _quantityController.text = value.toString();
                            setState(() => quantity = value.toDouble());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: quantity == value
                                ? NutriColors.primary
                                : NutriColors.primary.withOpacity(0.1),
                            foregroundColor: quantity == value
                                ? Colors.white
                                : NutriColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text('$value ${widget.food.unit}'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Calculated Nutrition
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculated Nutrition',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: NutriColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCalculatedItem(
                          label: 'Calories',
                          value: calculatedCalories,
                          unit: 'Cal',
                          color: NutriColors.accent,
                        ),
                        _buildCalculatedItem(
                          label: 'Protein',
                          value: calculatedProtein,
                          unit: 'g',
                          color: NutriColors.success,
                        ),
                        _buildCalculatedItem(
                          label: 'Fat',
                          value: calculatedFat,
                          unit: 'g',
                          color: NutriColors.danger,
                        ),
                        _buildCalculatedItem(
                          label: 'Carbs',
                          value: calculatedCarbs,
                          unit: 'g',
                          color: NutriColors.accentLight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Add Button
              saving
                  ? Center(
                child: CircularProgressIndicator(
                  color: NutriColors.primary,
                ),
              )
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NutriColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add to Daily Log',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionItem({
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: NutriColors.textSecondary,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 10,
            color: NutriColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatedItem({
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$label ($unit)',
          style: TextStyle(
            fontSize: 11,
            color: NutriColors.textSecondary,
          ),
        ),
      ],
    );
  }
}