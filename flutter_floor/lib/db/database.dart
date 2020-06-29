import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutterfloor/dao/person_dao.dart';
import 'package:flutterfloor/entity/person.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';





@Database(version: 1,entities: [Person])
abstract class AppDatabase extends FloorDatabase{
  PersonDao get personDao;
}