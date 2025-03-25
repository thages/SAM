import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/models/parcel.dart';
import '../../../shared/themes/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MockDataService _mockService = MockDataService();
  late Future<List<Parcel>> _parcelData;

  @override
  void initState() {
    super.initState();
    _parcelData = _mockService.fetchParcels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: FutureBuilder<List<Parcel>>(
        future: _parcelData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          List<Parcel> parcels = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Produção
                _buildSectionTitle("Produção por Talhão"),
                _buildChartCard(
                  _buildProductionChart(parcels),
                  legends: [
                    _buildLegendItem(AppColors.primary, "Produção (kg)"),
                  ],
                ),

                // Custo
                _buildSectionTitle("Custo por Hectare"),
                _buildChartCard(
                  _buildCostChart(parcels),
                  legends: [_buildLegendItem(AppColors.red, "Custo (R\$)")],
                ),

                // ROI
                _buildSectionTitle("ROI por Talhão"),
                _buildChartCard(
                  _buildROIChart(parcels),
                  legends: [_buildLegendItem(AppColors.blue, "ROI (%)")],
                ),

                // Clima
                _buildSectionTitle("Temperatura e Precipitação"),
                _buildChartCard(
                  _buildClimateChart(parcels),
                  legends: [
                    _buildLegendItem(AppColors.orange, "Temperatura (°C)"),
                    _buildLegendItem(AppColors.blue, "Precipitação (mm)"),
                  ],
                ),

                // Eficiência de Máquinas
                _buildSectionTitle("Eficiência de Máquinas"),
                _buildChartCard(
                  _buildMachinePerformanceChart(parcels),
                  legends: [
                    _buildLegendItem(AppColors.purple, "Eficiência (%)"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Titles above charts
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  // Card wrapper for each chart + legend
  Widget _buildChartCard(Widget chart, {required List<Widget> legends}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: 200, child: chart),
            const SizedBox(height: 10),
            Row(children: legends),
          ],
        ),
      ),
    );
  }

  // Legend item
  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, color: color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }

  // Production Chart (Bar)
  Widget _buildProductionChart(List<Parcel> parcels) {
    return _buildBarChart(
      data: parcels.map((p) => p.production.toDouble()).toList(),
      labels:
          parcels.map((p) => "${p.name[0]}.${p.name.characters.last}").toList(),
      color: AppColors.primary,
    );
  }

  // Cost Chart (Bar)
  Widget _buildCostChart(List<Parcel> parcels) {
    return _buildBarChart(
      data: parcels.map((p) => p.costPerHectare.toDouble()).toList(),
      labels:
          parcels.map((p) => "${p.name[0]}.${p.name.characters.last}").toList(),
      color: AppColors.red,
    );
  }

  // ROI Chart (Scatter)
  Widget _buildROIChart(List<Parcel> parcels) {
    // ROI = ((revenue - cost) / cost) * 100
    List<double> data =
        parcels.map((p) {
          return (p.revenue - p.cost) / p.cost * 100;
        }).toList();

    return _buildScatterChart(
      data: data,
      labels:
          parcels.map((p) => "${p.name[0]}.${p.name.characters.last}").toList(),
      color: AppColors.blue,
    );
  }

  // Climate Chart (Line) - temperature & rainfall
  Widget _buildClimateChart(List<Parcel> parcels) {
    List<double> temperatureData =
        parcels.map((p) => p.temperature.toDouble()).toList();
    List<double> rainfallData =
        parcels.map((p) => p.rainfall.toDouble()).toList();

    return _buildLineChart(
      data1: temperatureData,
      data2: rainfallData,
      labels:
          parcels.map((p) => "${p.name[0]}.${p.name.characters.last}").toList(),
      color1: AppColors.orange,
      color2: AppColors.blue,
    );
  }

  // Machine Performance Chart (Bar)
  Widget _buildMachinePerformanceChart(List<Parcel> parcels) {
    return _buildBarChart(
      data: parcels.map((p) => p.machineEfficiency.toDouble()).toList(),
      labels:
          parcels.map((p) => "${p.name[0]}.${p.name.characters.last}").toList(),
      color: AppColors.purple,
    );
  }

  // Generic Bar Chart
  Widget _buildBarChart({
    required List<double> data,
    required List<String> labels,
    required Color color,
  }) {
    return BarChart(
      BarChartData(
        barGroups: List.generate(
          data.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(toY: data[index], color: color, width: 15),
            ],
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx >= 0 && idx < labels.length) {
                  return Text(labels[idx]);
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  // Generic Scatter Chart
  Widget _buildScatterChart({
    required List<double> data,
    required List<String> labels,
    required Color color,
  }) {
    return ScatterChart(
      ScatterChartData(
        scatterSpots: List.generate(
          data.length,
          (index) => ScatterSpot(
            index.toDouble(),
            data[index],
            color: color,
            radius: 6,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx >= 0 && idx < labels.length) {
                  return Text(labels[idx]);
                }
                return const Text('');
              },
            ),
          ),
        ),
      ),
    );
  }

  // Generic Line Chart (for two data sets)
  Widget _buildLineChart({
    required List<double> data1,
    required List<double> data2,
    required List<String> labels,
    required Color color1,
    required Color color2,
  }) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data1.length,
              (index) => FlSpot(index.toDouble(), data1[index]),
            ),
            isCurved: true,
            color: color1,
          ),
          LineChartBarData(
            spots: List.generate(
              data2.length,
              (index) => FlSpot(index.toDouble(), data2[index]),
            ),
            isCurved: true,
            color: color2,
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx >= 0 && idx < labels.length) {
                  return Text(labels[idx]);
                }
                return const Text('');
              },
            ),
          ),
        ),
      ),
    );
  }
}
