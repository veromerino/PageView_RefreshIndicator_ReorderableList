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
  List<String> originalItems = List.generate(
      10, (index) => 'Item $index'); // Lista de elementos original
  List<String> items =
      List.generate(10, (index) => 'Item $index'); // Lista de elementos

  Widget _buildPage(int pageIndex) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página ${pageIndex + 1}'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(seconds: 3));
          setState(() {
            // Restaurar la lista original
            items = List.from(originalItems);
          });
        },
        child: _buildReorderableListView(),
      ),
    );
  }

  Widget _buildReorderableListView() {
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
