// import 'package:classdiary2/controller/web/dashboard_controller.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// // ignore_for_file: prefer_const_constructors
//
//   class AnimatedListSample extends StatelessWidget {
//
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   late ListModel<String> _list = ListModel<String>(listKey: _listKey, initialItems: <String>['aaa'], removedItemBuilder: _buildRemovedItem,);
//   late int _nextItem = 1;
//
//   @override
//   Widget _buildRemovedItem(int item, BuildContext context, Animation<double> animation) {
//     return CardItem(
//       animation: animation,
//       item: item,
//     );
//   }
//
//   void _insert() {
//     final int index = DashboardController.to.selectedItem.value == null ? _list.length : _list.indexOf(DashboardController.to.selectedItem.value!);
//     _list.insert(index, _nextItem++);
//   }
//
//   void _remove() {
//     if (DashboardController.to.selectedItem.value != null) {
//       _list.removeAt(_list.indexOf(DashboardController.to.selectedItem.value!));
//       DashboardController.to.selectedItem.value = null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('AnimatedList'),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.add_circle),
//               onPressed: _insert,
//               tooltip: 'insert a new item',
//             ),
//             IconButton(
//               icon: const Icon(Icons.remove_circle),
//               onPressed: _remove,
//               tooltip: 'remove the selected item',
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: AnimatedList(
//             key: _listKey,
//             initialItemCount: _list.length,
//             itemBuilder: (BuildContext context, int index, Animation<double> animation) {
//               return Obx(() => CardItem(
//                   animation: animation,
//                   item: _list[index],
//                   selected: DashboardController.to.selectedItem.value == _list[index],
//                   onTap: () {
//                     DashboardController.to..selectedItem.value = DashboardController.to.selectedItem.value == _list[index] ? null : _list[index];
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// typedef RemovedItemBuilder<T> = Widget Function(T item, BuildContext context, Animation<double> animation);
//
// class ListModel<E> {
//   ListModel({
//     required this.listKey,
//     required this.removedItemBuilder,
//     Iterable<E>? initialItems,
//   }) : _items = List<E>.from(initialItems ?? <E>[]);
//
//   final GlobalKey<AnimatedListState> listKey;
//   final RemovedItemBuilder<E> removedItemBuilder;
//   final List<E> _items;
//
//   AnimatedListState? get _animatedList => listKey.currentState;
//
//   void insert(int index, E item) {
//     _items.insert(index, item);
//     _animatedList!.insertItem(index);
//   }
//
//   E removeAt(int index) {
//     final E removedItem = _items.removeAt(index);
//     if (removedItem != null) {
//       _animatedList!.removeItem(
//         index,
//             (BuildContext context, Animation<double> animation) {
//           return removedItemBuilder(removedItem, context, animation);
//         },
//       );
//     }
//     return removedItem;
//   }
//
//   int get length => _items.length;
//
//   E operator [](int index) => _items[index];
//
//   int indexOf(E item) => _items.indexOf(item);
// }
//
// class CardItem extends StatelessWidget {
//   const CardItem({
//     Key? key,
//     this.onTap,
//     this.selected = false,
//     required this.animation,
//     required this.item,
//   })  : assert(item >= 0),
//         super(key: key);
//
//   final Animation<double> animation;
//   final VoidCallback? onTap;
//   final int item;
//   final bool selected;
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle textStyle = Theme.of(context).textTheme.headline4!;
//     if (selected) {
//       textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
//     }
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: SizeTransition(
//         sizeFactor: animation,
//         child: GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: onTap,
//           child: SizedBox(
//             height: 80.0,
//             child: Card(
//               color: Colors.primaries[item % Colors.primaries.length],
//               child: Center(
//                 child: Text('Item $item', style: textStyle),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
