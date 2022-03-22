
import 'package:get_it/get_it.dart';
import 'package:hrm/core/services/api.dart';
import 'package:hrm/core/services/employee_service.dart';
import 'package:hrm/core/view_models/employee_view_model.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => Api());
  locator.registerFactory(() => EmployeeService());
  locator.registerFactory(() => EmployeeViewModel());
}