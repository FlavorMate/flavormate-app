import 'package:fl_chart/fl_chart.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/utils/u_double.dart';
import 'package:flutter/material.dart';

class RecipeNutritionChart extends StatefulWidget {
  final double space;
  final double size;

  final bool showLabels;

  final Nutrition nutrition;

  const RecipeNutritionChart({
    super.key,
    this.space = 4,
    this.size = 64,
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
              // setState(() {
              //   if (!event.isInterestedForInteractions ||
              //       pieTouchResponse == null ||
              //       pieTouchResponse.touchedSection == null) {
              //     touchedIndex = -1;
              //     return;
              //   }
              //   touchedIndex =
              //       pieTouchResponse.touchedSection!.touchedSectionIndex;
              // });
            },
          ),
          sectionsSpace: widget.space,
          // centerSpaceRadius: widget.centerSpace,
          sections: showingSections(),
        ),

        swapAnimationDuration: Duration(milliseconds: 150),
        // Optional
        swapAnimationCurve: Curves.linear, // Optional
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final fontSize = 16.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    return [
      if (UDouble.isPositive(widget.nutrition.carbohydrates))
        PieChartSectionData(
          color: NutritionType.carbohydrates.colorLight,
          value: widget.nutrition.carbohydratesPercent,
          showTitle: widget.showLabels,
          title: '${widget.nutrition.carbohydratesPercent.beautify}%',
          radius: widget.size / 4,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          // badgeWidget: _Badge(
          //   'assets/icons/ophthalmology-svgrepo-com.svg',
          //   size: widgetSize,
          //   borderColor: AppColors.contentColorBlack,
          // ),
          badgePositionPercentageOffset: .98,
        ),
      if (UDouble.isPositive(widget.nutrition.fat))
        PieChartSectionData(
          color: NutritionType.fat.colorLight,
          value: widget.nutrition.fatPercent,
          showTitle: widget.showLabels,
          title: '${widget.nutrition.fatPercent.beautify}%',
          radius: widget.size / 4,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          // badgeWidget: _Badge(
          //   'assets/icons/ophthalmology-svgrepo-com.svg',
          //   size: widgetSize,
          //   borderColor: AppColors.contentColorBlack,
          // ),
          badgePositionPercentageOffset: .98,
        ),
      if (UDouble.isPositive(widget.nutrition.fiber))
        PieChartSectionData(
          color: NutritionType.fiber.colorLight,
          value: widget.nutrition.fiberPercent,
          showTitle: widget.showLabels,
          title: '${widget.nutrition.fiberPercent.beautify}%',
          radius: widget.size / 4,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          // badgeWidget: _Badge(
          //   'assets/icons/ophthalmology-svgrepo-com.svg',
          //   size: widgetSize,
          //   borderColor: AppColors.contentColorBlack,
          // ),
          badgePositionPercentageOffset: .98,
        ),
      if (UDouble.isPositive(widget.nutrition.proteins))
        PieChartSectionData(
          color: NutritionType.proteins.colorLight,
          value: widget.nutrition.proteinsPercent,
          showTitle: widget.showLabels,
          title: '${widget.nutrition.proteinsPercent.beautify}%',
          radius: widget.size / 4,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          // badgeWidget: _Badge(
          //   'assets/icons/ophthalmology-svgrepo-com.svg',
          //   size: widgetSize,
          //   borderColor: AppColors.contentColorBlack,
          // ),
          badgePositionPercentageOffset: .98,
        ),
      if (UDouble.isPositive(widget.nutrition.salt))
        PieChartSectionData(
          color: NutritionType.salt.colorLight,
          value: widget.nutrition.saltPercent,
          showTitle: widget.showLabels,
          title: '${widget.nutrition.saltPercent.beautify}%',
          radius: widget.size / 4,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          // badgeWidget: _Badge(
          //   'assets/icons/ophthalmology-svgrepo-com.svg',
          //   size: widgetSize,
          //   borderColor: AppColors.contentColorBlack,
          // ),
          badgePositionPercentageOffset: .98,
        ),
      if (UDouble.isPositive(widget.nutrition.sodium))
        PieChartSectionData(
          color: NutritionType.sodium.colorLight,
          value: widget.nutrition.sodiumPercent,
          showTitle: widget.showLabels,
          title: '${widget.nutrition.sodiumPercent.beautify}%',
          radius: widget.size / 4,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          // badgeWidget: _Badge(
          //   'assets/icons/ophthalmology-svgrepo-com.svg',
          //   size: widgetSize,
          //   borderColor: AppColors.contentColorBlack,
          // ),
          badgePositionPercentageOffset: .98,
        )
    ];
  }
}
