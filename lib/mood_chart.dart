import 'dart:math' as math;
import 'package:ekaant/constants/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BarChartSample7 extends StatefulWidget {
  final bool build;
  BarChartSample7({super.key, required this.build});

  final dataList = [
    const _BarData(18),
    const _BarData(17),
    const _BarData(10),
    const _BarData(2.5),
    const _BarData(2),
  ];

  @override
  State<BarChartSample7> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartSample7> {
  final facesData = [
    MdiIcons.emoticonOutline,
    MdiIcons.emoticonHappyOutline,
    MdiIcons.emoticonNeutralOutline,
    MdiIcons.emoticonSadOutline,
    MdiIcons.emoticonCryOutline,
  ];

  BarChartGroupData generateBarGroup(
    int x,
    double value,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          gradient: _barsGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          width: 17,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.build) {
      return Padding(
        padding:
            const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 10),
        child: AspectRatio(
          aspectRatio: 1.4,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              borderData: FlBorderData(
                show: true,
                border: const Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  drawBehindEverything: true,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: _IconWidget(
                            isSelected: touchedGroupIndex == index,
                            icon: facesData[index]),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(),
                topTitles: AxisTitles(),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white,
                  strokeWidth: 1,
                ),
              ),
              barGroups: widget.dataList.asMap().entries.map((e) {
                final index = e.key;
                final data = e.value;
                return generateBarGroup(
                  index,
                  data.value,
                );
              }).toList(),
              maxY: 20,
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipMargin: 0,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      rod.toY.toString(),
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ekaantGreen,
                        fontSize: 18,
                      ),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  if (event.isInterestedForInteractions &&
                      response != null &&
                      response.spot != null) {
                    setState(() {
                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                    });
                  } else {
                    setState(() {
                      touchedGroupIndex = -1;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class _BarData {
  const _BarData(this.value);
  final double value;
}

LinearGradient get _barsGradient => const LinearGradient(
      colors: [ekaantDarkGreen, ekaantGreen],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({required this.isSelected, required this.icon})
      : super(duration: const Duration(milliseconds: 300));
  final bool isSelected;
  final IconData icon;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Icon(
        widget.icon,
        color: ekaantGreen,
        size: 28,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
