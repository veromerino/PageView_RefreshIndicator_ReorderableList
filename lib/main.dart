import 'package:flutter/material.dart';

void main() {
  runApp(RefreshIndicatorExampleApp());
}

class RefreshIndicatorExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RefreshIndicatorExample(),
    );
  }
}

class RefreshIndicatorExample extends StatefulWidget {
  @override
  State<RefreshIndicatorExample> createState() =>
      _RefreshIndicatorExampleState();
}

class _RefreshIndicatorExampleState extends State<RefreshIndicatorExample> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<List<String>> originalItems = [
    List.generate(4, (index) => 'Item $index'),
    List.generate(4, (index) => 'Item $index'),
    List.generate(4, (index) => 'Item $index'),
  ]; // Lista de elementos original

  List<List<String>> items = [
    List.generate(4, (index) => 'Item $index'),
    List.generate(4, (index) => 'Item $index'),
    List.generate(4, (index) => 'Item $index'),
  ]; // Lista de elementos

  Widget _buildPage(int pageIndex) {
    Color pageColor;
    switch (pageIndex) {
      case 0:
        pageColor = Colors.pink; // Primera página rosada
        break;
      case 1:
        pageColor = Colors.blue; // Segunda página celeste
        break;
      case 2:
        pageColor = Colors.yellow; // Tercera página amarilla
        break;
      default:
        pageColor = Colors.white; // Por defecto, blanco
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Página ${pageIndex + 1}'),
        backgroundColor: pageColor, // Cambiar el color de la AppBar
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: pageColor, // Cambiar el color del fondo del cuerpo
        strokeWidth: 4.0,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(seconds: 3));
          setState(() {
            // Restaurar la lista original
            items[pageIndex] = List.from(originalItems[pageIndex]);
          });
        },
        child: _buildReorderableListView(items[pageIndex]),
      ),
    );
  }

  Widget _buildReorderableListView(List<String> items) {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          String item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
      children: List.generate(
        items.length,
        (index) => ListTile(
          key: ValueKey(items[index]),
          title: Text(items[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildPage(index);
      },
    );
  }
}
