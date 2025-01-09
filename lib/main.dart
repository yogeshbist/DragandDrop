import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop macOS Status Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StatusBarDemo(),
    );
  }
}

class StatusBarDemo extends StatefulWidget {
  @override
  _StatusBarDemoState createState() => _StatusBarDemoState();
}

class _StatusBarDemoState extends State<StatusBarDemo> {
  // Simulate a list of items in the status bar
  List<DraggableItem> statusBarItems = [
    DraggableItem(id: 0, label: "Wi-Fi", icon: Icons.person),
    DraggableItem(id: 1, label: "Bluetooth", icon: Icons.message),
    DraggableItem(id: 2, label: "Battery", icon: Icons.call),
    DraggableItem(id: 3, label: "Time", icon: Icons.camera),
    DraggableItem(id: 3, label: "Time", icon: Icons.photo),
  ];

  // Update the list after dragging and dropping
  void onItemDropped(DraggableItem item, int toIndex) {
    setState(() {
      final fromIndex = statusBarItems.indexOf(item);
      if (fromIndex != -1 && fromIndex != toIndex) {
        // Remove the item from its original position and insert it at the new position
        statusBarItems.removeAt(fromIndex);
        statusBarItems.insert(toIndex, item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Align(
        alignment:Alignment.center,
        child:Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height:MediaQuery.of(context).size.width * 0.3,
            padding: EdgeInsets.all(10),
            color: Colors.black12,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(statusBarItems.length, (index) {
                  return DragTarget<DraggableItem>(
                    onAccept: (item) {
                      onItemDropped(item, index);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DraggableItemWidget(
                          item: statusBarItems[index],
                          isBeingDragged: candidateData.isNotEmpty,
                        ),
                      );
                    },
                  );
                }),
              ),)
        ),
      ),
    );
  }
}

class DraggableItem {
  final int id;
  final String label;
  final IconData icon;

  DraggableItem({required this.id, required this.label, required this.icon});
}

class DraggableItemWidget extends StatelessWidget {
  final DraggableItem item;
  final bool isBeingDragged;

  const DraggableItemWidget({Key? key, required this.item, required this.isBeingDragged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.primaries[item.id % Colors.primaries.length];
    return Draggable<DraggableItem>(
      data: item,  // Pass the actual DraggableItem data here
      feedback: Material(
          color: Colors.transparent,
          child: Center(
            child:Container(
              padding: EdgeInsets.all(8),
              child: Icon(item.icon, size: 32, color: Colors.blue),
            ),)
      ),
      childWhenDragging: Container(),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor,  // Apply the color here as well
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(item.icon, size: 32, color: isBeingDragged ? Colors.grey : Colors.black54),
      ),
    );
  }
}