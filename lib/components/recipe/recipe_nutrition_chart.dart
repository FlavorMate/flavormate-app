import 'package:fl_chart/fl_chart.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flutter/material.dart';

class RecipeNutritionChart extends StatefulWidget {
  final double space;
  final double size;

  final Function(int)? onTouch;

  final bool showLabels;

  final Nutrition nutrition;

  const RecipeNutritionChart({
    super.key,
    this.space = 4,
    this.size = 64,
    this.onTouch,
    this.showLabels = true,
    required this.nutrition,
  });

  @override
  State<StatefulWidget> createState() => _RecipeNutritionChartState();
}

class _RecipeNutritionChartState extends State<RecipeNutritionChart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  widget.onTouch?.call(-1);
                  return;
                }
                widget.onTouch?.call(
                  pieTouchResponse.touchedSection!.touchedSectionIndex,
                );
              });
            },
          ),
          sectionsSpace: widget.space,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
    );

    return [
      PieChartSectionData(
        color: NutritionType.carbohydrates.getColor(context),
        value: widget.nutrition.carbohydratesPercent,
        showTitle: widget.showLabels,
        title: '${widget.nutrition.carbohydratesPercent.beautify}%',
        radius: widget.size / 4,
        titleStyle: textStyle,
      ),
      PieChartSectionData(
        color: NutritionType.fat.getColor(context),
        value: widget.nutrition.fatPercent,
        showTitle: widget.showLabels,
        title: '${widget.nutrition.fatPercent.beautify}%',
        radius: widget.size / 4,
        titleStyle: textStyle,
      ),
      PieChartSectionData(
        color: NutritionType.fiber.getColor(context),
        value: widget.nutrition.fiberPercent,
        showTitle: widget.showLabels,
        title: '${widget.nutrition.fiberPercent.beautify}%',
        radius: widget.size / 4,
        titleStyle: textStyle,
      ),
      PieChartSectionData(
        color: NutritionType.proteins.getColor(context),
        value: widget.nutrition.proteinsPercent,
        showTitle: widget.showLabels,
        title: '${widget.nutrition.proteinsPercent.beautify}%',
        radius: widget.size / 4,
        titleStyle: textStyle,
      ),
      PieChartSectionData(
        color: NutritionType.salt.getColor(context),
        value: widget.nutrition.saltPercent,
        showTitle: widget.showLabels,
        title: '${widget.nutrition.saltPercent.beautify}%',
        radius: widget.size / 4,
        titleStyle: textStyle,
      ),
      PieChartSectionData(
        color: NutritionType.sodium.getColor(context),
        value: widget.nutrition.sodiumPercent,
        showTitle: widget.showLabels,
        title: '${widget.nutrition.sodiumPercent.beautify}%',
        radius: widget.size / 4,
        titleStyle: textStyle,
      )
    ];
  }
}
