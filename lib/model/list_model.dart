import 'package:bricktime/model/prono.dart';
import 'package:bricktime/model/prono_row.dart';
import 'package:flutter/material.dart';

class ListModel {
  ListModel(this.listKey, items) : this.items = new List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List<Prono> items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Prono item) {
    items.insert(index, item);
    _animatedList.insertItem(index, duration: new Duration(milliseconds: 150));
  }

  Prono removeAt(int index) {
    final Prono removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
          index,
              (context, animation) => new PronoRow(
            prono: removedItem,
            animation: animation,
          ),
          duration: new Duration(milliseconds: (150 + 200*(index/length)).toInt())
      );
    }
    return removedItem;
  }

  int get length => items.length;

  Prono operator [](int index) => items[index];

  int indexOf(Prono item) => items.indexOf(item);
}