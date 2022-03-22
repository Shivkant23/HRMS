


import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:hrm/core/models/employee_list_response.dart';
import 'package:hrm/core/models/updated_employee.dart';
import 'package:hrm/core/providers/employee_provider.dart';
import 'package:hrm/core/services/employee_service.dart';
import 'package:hrm/core/services/service_locator.dart';
import 'package:provider/provider.dart';

class EmployeeViewModel{
  final EmployeeService _employeeService = locator<EmployeeService>();
  List<Data> listOfEmployees = [];

  Future<void> searchEmployee(BuildContext context, String query) async {
    EmployeeProvider employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    if(query.isNotEmpty){
      List<Data> list = [];
      for (var item in employeeProvider.getListOfEmployees) {
        if(item.employeeName!.contains(query)){
          list.add(item);
        }
      }
      employeeProvider.setListOfEmployees(list);
    }else{
      employeeProvider.setListOfEmployees(listOfEmployees);
    }
  }
  
  Future<List<Data>> listOfEmployee(BuildContext context) async {
      var response = await _employeeService.listOfEmployee();
      if (response.data != null) {
        EmployeeProvider employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
        employeeProvider.setListOfEmployees(response.data!);
        listOfEmployees = employeeProvider.getListOfEmployees;
        return response.data!;
      } else {
        BotToast.showText(text: "Please Try Again!");
        return [];
      }
  }

  Future<UpdatedEmployee?> updateTheEmployee(BuildContext context, Data emplyee) async {
      var response = await _employeeService.updateTheEmployee(emplyee);
      EmployeeProvider employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
      if (response != null) {
        var list = employeeProvider.getListOfEmployees;
        list.map((e){
          if(e.id == emplyee.id){
            e.employeeName = response.data!.name;
            e.employeeAge = int.parse(response.data!.age!);
            e.employeeSalary = int.parse(response.data!.salary!);
          }
        });
        employeeProvider.setListOfEmployees(list);
        return response.data;
      } else {
        BotToast.showText(text: "Please Try Again!");
        return response!.data;
      }
  }

  Future<UpdatedEmployee?> createEmployee(BuildContext context, UpdatedEmployee emplyee) async {
    var response = await _employeeService.createEmployee(emplyee);
    EmployeeProvider employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    if (response != null) {
      var list = employeeProvider.getListOfEmployees;
      list.add(
        Data(
          employeeAge: int.parse(response.data!.age!), 
          employeeSalary: int.parse(response.data!.salary!), 
          employeeName: response.data!.name,
          id: employeeProvider.getListOfEmployees.last.id! + 1
        )
      );
      employeeProvider.setListOfEmployees(list);
      return response.data;
    } else {
      BotToast.showText(text: "Please Try Again!");
      return response!.data;
    }
  }

  Future<UpdatedEmployee?> deleteEmployee(BuildContext context, Data emplyee) async {
    var response = await _employeeService.deleteEmployee(emplyee);
    EmployeeProvider employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    if (response != null) {
      var list = employeeProvider.getListOfEmployees;
      for (var item in list) {
        if(item.id == emplyee.id){
          list.remove(item);
          break;
        }
      }
      employeeProvider.setListOfEmployees(list);
      BotToast.showText(text: "Employee ${emplyee.employeeName} is deleted.");
    } else {
      BotToast.showText(text: "Please Try Again!");
    }
  }
}