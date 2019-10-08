import 'package:bricktime/model/result.dart';
import 'package:bricktime/model/result_row.dart';
import 'package:flutter/material.dart';

class ResultModel {
  ResultModel(this.listKey, items) : this.items = new List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List<Result> items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Result item) {
    items.insert(index, item);
    _animatedList.insertItem(index, duration: new Duration(milliseconds: 150));
  }

  Result removeAt(int index) {
    final Result removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
          index,
              (context, animation) => new ResultRow(
            result: removedItem,
            animation: animation,
          ),
          duration: new Duration(milliseconds: (150 + 200*(index/length)).toInt())
      );
    }
    return removedItem;
  }

  int get length => items.length;

  Result operator [](int index) => items[index];

  int indexOf(Result item) => items.indexOf(item);
}