


import 'package:hrm/core/models/updated_employee.dart';
import 'package:hrm/core/services/service_locator.dart';
import 'package:hrm/core/services/api.dart';
import 'package:hrm/core/models/employee_list_response.dart';



class EmployeeService{
  Api api = locator<Api>();
  
  Future<EmplyeeListResponse> listOfEmployee() {
    return api.listOfEmployee();
  }

  Future<UpdatedEmplyeeResponse?> updateTheEmployee(Data emplyee) {
    return api.updateTheEmployee(emplyee);
  }

  Future<UpdatedEmplyeeResponse?> createEmployee(UpdatedEmployee emplyee) {
    return api.createEmployee(emplyee);
  }

  Future<UpdatedEmplyeeResponse?> deleteEmployee(Data emplyee) {
    return api.deleteEmployee(emplyee);
  }
}