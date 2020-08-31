import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/operations/open_activities.dart';



class OpenActivitiesManager extends Model {

  final SelectionDelegate<Category> categoriesSelectionDelegate = SelectionDelegate<Category>();
  

  Future loadOpenActivities() {



  }

}