import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DataBase {
  bool isFavorit = false;

  Future<void> putFavorite(String key, String value) async {
    var boxFavorite = await Hive.openBox<String>('FavoriteBox');
    await boxFavorite.put(key, value);
    await boxFavorite.close();
  }

  Future<void> deleteFavorite(String key) async {
    var boxFavorite = await Hive.openBox<String>('FavoriteBox');
    await boxFavorite.delete(key);
    await boxFavorite.close();
  }

  Future<bool> containsFavorite(String key) async {
    var boxFavorite = await Hive.openBox<String>('FavoriteBox');
    bool flag = boxFavorite.containsKey(key);
    await boxFavorite.close();
    return flag;
  }

  Future<List<Widget>> getListFavorite() async {
    var boxFavorite = await Hive.openBox<String>('FavoriteBox');
    var map = boxFavorite.toMap();
    var list = <Widget>[];
    map.forEach((key, value) {
      list.add(Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '$key',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(value, style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ));
    });
    await boxFavorite.close();
    return list;
  }

  Future<void> putLearn(String key, String value) async {
    var boxLearn = await Hive.openBox<String>('LearnBox');
    await boxLearn.put(key, value);
    await boxLearn.close();
  }

  Future<void> deleteLearn(String key) async {
    var boxLearn = await Hive.openBox<String>('LearnBox');
    await boxLearn.delete(key);
    await boxLearn.close();
  }

  Future<bool> containsLearn(String key) async {
    var boxLearn = await Hive.openBox<String>('LearnBox');
    bool flag = boxLearn.containsKey(key);
    await boxLearn.close();
    return flag;
  }

  Future<Map<String, String>> getListLearn(int index) async {
    final boxLearn = await Hive.openBox<String>('LearnBox');
    final key = boxLearn.keyAt(index);
    final value = boxLearn.getAt(index);
    final Map<String, String> map;
    if (key != null) {
      map = {'$key': '$value'};
    } else {
      map = {' ': ' '};
    }
    await boxLearn.close();
    return map;
  }

  Future<int> getLenghtLearnBox() async {
    final boxLearn = await Hive.openBox<String>('LearnBox');
    return boxLearn.length;
  }
}
