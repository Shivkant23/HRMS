

import 'package:flutter/cupertino.dart';
import 'package:hrm/core/models/employee_list_response.dart';

class EmployeeProvider extends ChangeNotifier{
  List<Data> _listOfEmployees = [];

  List<Data> get getListOfEmployees => _listOfEmployees;

  void setListOfEmployees(List<Data> list) {
    _listOfEmployees = list;
    notifyListeners();
  }

  bool isEdit = true;
  bool get getEditFlag => isEdit;

  void setEditFlag(bool flag) {
    isEdit = flag;
    notifyListeners();
  }
}