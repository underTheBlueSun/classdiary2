import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// class AniList extends StatefulWidget {
//   const AniList({Key? key}) : super(key: key);
//
//   @override
//   _AniListState createState() => _AniListState();
// }

class AniList extends StatelessWidget {
  final _items = ['aaa', 'bbbb'];

  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void _addItem() {
    _items.insert(0, "Item ${_items.length + 1}");
    _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 500));
  }

  void _removeItem(int index) {
    _key.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: const Card(
          // margin: EdgeInsets.all(10),
          // elevation: 10,
          color: Colors.purple,
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text("Goodbye", style: TextStyle(fontSize: 24)),
          ),
        ),
      );
    },

    duration: const Duration(milliseconds: 500));
    _items.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedList(
        key: _key,
        initialItemCount: _items.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (_, index, animation) {
          return SizeTransition(
            key: UniqueKey(),
            sizeFactor: animation,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.7),)
                ),
              ),
              child: ListTile(
                leading: Text('111'),
                subtitle: Text('sub'),
                contentPadding: const EdgeInsets.all(10),
                title: Text('${_items[index]} / ${index}', style: const TextStyle(fontSize: 24)),
                trailing:
                IconButton(icon: const Icon(Icons.delete),
                  onPressed: () {
                    _removeItem(index);
                  }
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _addItem, child: const Icon(Icons.add)),
    );
  }
}