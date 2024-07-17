import 'package:flutter/material.dart';

class DraggableButtonsPage extends StatefulWidget {
  const DraggableButtonsPage({super.key});

  @override
  _DraggableButtonsPageState createState() => _DraggableButtonsPageState();
}

class _DraggableButtonsPageState extends State<DraggableButtonsPage> {
  Offset position1 = const Offset(50, 100);
  Offset position2 = const Offset(150, 100);
  Offset position3 = const Offset(250, 100);

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Draggable Buttons'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              buildDraggableButton(position1, (offset) {
                setState(() {
                  position1 = adjustOffset(
                      offset, constraints, appBarHeight, statusBarHeight, key1);
                });
              }, Colors.red, 'Button 1', key1),
              buildDraggableButton(position2, (offset) {
                setState(() {
                  position2 = adjustOffset(
                      offset, constraints, appBarHeight, statusBarHeight, key2);
                });
              }, Colors.green, 'Button 2', key2),
              buildDraggableButton(position3, (offset) {
                setState(() {
                  position3 = adjustOffset(
                      offset, constraints, appBarHeight, statusBarHeight, key3);
                });
              }, Colors.blue, 'Button 3', key3),
            ],
          );
        },
      ),
    );
  }

  Widget buildDraggableButton(Offset position, Function(Offset) onDragEnd,
      Color color, String label, GlobalKey key) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: buildButton(color, label),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          onDragEnd(details.offset);
        },
        child: buildButton(color, label, key),
      ),
    );
  }

  Widget buildButton(Color color, String label, [GlobalKey? key]) {
    return Material(
      key: key,
      color: color,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Offset adjustOffset(Offset offset, BoxConstraints constraints,
      double appBarHeight, double statusBarHeight, GlobalKey key) {
    // Default to some reasonable values if the context is not yet available
    double width = 50.0; // Default button width
    double height = 50.0; // Default button height

    if (key.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      width = renderBox.size.width;
      height = renderBox.size.height;
    }

    final double newX = offset.dx.clamp(0.0, constraints.maxWidth - width);
    final double newY = (offset.dy - appBarHeight - statusBarHeight)
        .clamp(0.0, constraints.maxHeight - height);

    return Offset(newX, newY);
  }
}
