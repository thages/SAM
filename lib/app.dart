import 'package:flutter/material.dart';
import 'core/services/mock_data_service.dart';

import 'features/dashboard/dashboard_screen.dart';
import 'features/parcels/parcels_screen.dart';
import 'features/products/products_screen.dart';
import 'features/machines/machines_screen.dart';
import 'features/recommendations/recommendations_screen.dart';

class MyFarmApp extends StatefulWidget {
  const MyFarmApp({Key? key}) : super(key: key);

  @override
  State<MyFarmApp> createState() => _MyFarmAppState();
}

class _MyFarmAppState extends State<MyFarmApp> {
  final mockService = MockDataService();

  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(),
      ParcelsScreen(mockService: mockService),
      ProductsScreen(mockService: mockService),
      MachinesScreen(mockService: mockService),
      RecommendationsScreen(mockService: mockService, isConsultant: true),
    ];
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management MVP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gestão Estratégica Agrícola'),
          // backgroundColor: Colors.green[800], // Change this color
          // surfaceTintColor: Colors.transparent,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Text(
                  'Menu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Perfil'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Perfil...')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configurações...')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Sobre'),
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                    context: context,
                    applicationName: 'Farm Management MVP',
                    applicationVersion: '1.0.0',
                  );
                },
              ),
            ],
          ),
        ),

        body: _screens[_selectedIndex],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            // backgroundColor: Colors.green[100],
            onTap: _onNavItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.green[700],
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Talhões'),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Insumos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.agriculture),
                label: 'Máquinas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.tips_and_updates),
                label: 'Recomendações',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
