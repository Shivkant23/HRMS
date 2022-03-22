import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:hrm/core/models/employee_list_response.dart';
import 'package:hrm/core/models/updated_employee.dart';
import 'package:http/http.dart' as http;

class Api{
  String baseUrl = "http://dummy.restapiexample.com/api/v1";
  Api(){}

  Future<EmplyeeListResponse> listOfEmployee() async {
    var res = await http.get(Uri.parse(baseUrl+'/employees'));
    String data = "{\"status\":\"success\",\"data\":[{\"id\":1,\"employee_name\":\"TigerNixon\",\"employee_salary\":320800,\"employee_age\":61,\"profile_image\":\"\"},{\"id\":2,\"employee_name\":\"GarrettWinters\",\"employee_salary\":170750,\"employee_age\":63,\"profile_image\":\"\"},{\"id\":3,\"employee_name\":\"AshtonCox\",\"employee_salary\":86000,\"employee_age\":66,\"profile_image\":\"\"},{\"id\":4,\"employee_name\":\"CedricKelly\",\"employee_salary\":433060,\"employee_age\":22,\"profile_image\":\"\"},{\"id\":5,\"employee_name\":\"AiriSatou\",\"employee_salary\":162700,\"employee_age\":33,\"profile_image\":\"\"},{\"id\":6,\"employee_name\":\"BrielleWilliamson\",\"employee_salary\":372000,\"employee_age\":61,\"profile_image\":\"\"},{\"id\":7,\"employee_name\":\"HerrodChandler\",\"employee_salary\":137500,\"employee_age\":59,\"profile_image\":\"\"},{\"id\":8,\"employee_name\":\"RhonaDavidson\",\"employee_salary\":327900,\"employee_age\":55,\"profile_image\":\"\"},{\"id\":9,\"employee_name\":\"ColleenHurst\",\"employee_salary\":205500,\"employee_age\":39,\"profile_image\":\"\"},{\"id\":10,\"employee_name\":\"SonyaFrost\",\"employee_salary\":103600,\"employee_age\":23,\"profile_image\":\"\"},{\"id\":11,\"employee_name\":\"JenaGaines\",\"employee_salary\":90560,\"employee_age\":30,\"profile_image\":\"\"},{\"id\":12,\"employee_name\":\"QuinnFlynn\",\"employee_salary\":342000,\"employee_age\":22,\"profile_image\":\"\"},{\"id\":13,\"employee_name\":\"ChardeMarshall\",\"employee_salary\":470600,\"employee_age\":36,\"profile_image\":\"\"},{\"id\":14,\"employee_name\":\"HaleyKennedy\",\"employee_salary\":313500,\"employee_age\":43,\"profile_image\":\"\"},{\"id\":15,\"employee_name\":\"TatyanaFitzpatrick\",\"employee_salary\":385750,\"employee_age\":19,\"profile_image\":\"\"},{\"id\":16,\"employee_name\":\"MichaelSilva\",\"employee_salary\":198500,\"employee_age\":66,\"profile_image\":\"\"},{\"id\":17,\"employee_name\":\"PaulByrd\",\"employee_salary\":725000,\"employee_age\":64,\"profile_image\":\"\"},{\"id\":18,\"employee_name\":\"GloriaLittle\",\"employee_salary\":237500,\"employee_age\":59,\"profile_image\":\"\"},{\"id\":19,\"employee_name\":\"BradleyGreer\",\"employee_salary\":132000,\"employee_age\":41,\"profile_image\":\"\"},{\"id\":20,\"employee_name\":\"DaiRios\",\"employee_salary\":217500,\"employee_age\":35,\"profile_image\":\"\"},{\"id\":21,\"employee_name\":\"JenetteCaldwell\",\"employee_salary\":345000,\"employee_age\":30,\"profile_image\":\"\"},{\"id\":22,\"employee_name\":\"YuriBerry\",\"employee_salary\":675000,\"employee_age\":40,\"profile_image\":\"\"},{\"id\":23,\"employee_name\":\"CaesarVance\",\"employee_salary\":106450,\"employee_age\":21,\"profile_image\":\"\"},{\"id\":24,\"employee_name\":\"DorisWilder\",\"employee_salary\":85600,\"employee_age\":23,\"profile_image\":\"\"}],\"message\":\"Successfully!Allrecordshasbeenfetched.\"}";
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      return EmplyeeListResponse.fromJson(jsonData);
    } else if (res.statusCode == 429 ) {
      var jsonData = jsonDecode(data);
      return EmplyeeListResponse.fromJson(jsonData);
    } else {
      throw "Unable to retrieve list.";
    }
  }

  Future<UpdatedEmplyeeResponse?> createEmployee(UpdatedEmployee emplyee) async {
    var response = await http.post(Uri.parse(baseUrl+'/create'),
      body: {"name":emplyee.name,"salary":"${emplyee.salary}","age":"${emplyee.age}"},
    );
    String data = "{\"status\":\"success\",\"data\":{\"name\":\"TigerNixon\",\"salary\":\"320800\",\"age\":\"10\"},\"message\":\"Successfully!Recordhasbeenupdated.\"}";
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return UpdatedEmplyeeResponse.fromJson(jsonData);
    } else if (response.statusCode == 429 ) {
      var jsonData = jsonDecode(data);
      jsonData['data']['name'] = emplyee.name;
      jsonData['data']['age'] = emplyee.age.toString();
      jsonData['data']['salary'] = emplyee.salary.toString();
      return UpdatedEmplyeeResponse.fromJson(jsonData);
    } else {
      BotToast.showText(text: "Unable to create employee.");
    }
  }

  Future<UpdatedEmplyeeResponse?> updateTheEmployee(Data emplyee) async {
    var response = await http.put(Uri.parse(baseUrl+'/update/${emplyee.id}'),
      body: {"name":emplyee.employeeName,"salary":"${emplyee.employeeSalary}","age":"${emplyee.employeeAge}"},
    );
    String data = "{\"status\":\"success\",\"data\":{\"name\":\"TigerNixon\",\"salary\":\"320800\",\"age\":\"10\"},\"message\":\"Successfully!Recordhasbeenupdated.\"}";
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return UpdatedEmplyeeResponse.fromJson(jsonData);
    } else if (response.statusCode == 429 ) {
      var jsonData = jsonDecode(data);
      jsonData['data']['name'] = emplyee.employeeName;
      jsonData['data']['age'] = emplyee.employeeAge.toString();
      jsonData['data']['salary'] = emplyee.employeeSalary.toString();
      return UpdatedEmplyeeResponse.fromJson(jsonData);
    } else {
      BotToast.showText(text: "Unable to update employee.");
    }
  }

  Future<UpdatedEmplyeeResponse?> deleteEmployee(Data emplyee) async {
    var response = await http.get(Uri.parse(baseUrl+'/delete/${emplyee.id}'));
    String data = "{\"status\":\"success\",\"message\":\"successfully!deletedRecords\"}";
    if (response != null) {
      var jsonData = jsonDecode(response.body);
      return UpdatedEmplyeeResponse.fromJson(jsonData);
    } else if (response.statusCode == 429 ) {
      var jsonData = jsonDecode(data);
      return UpdatedEmplyeeResponse.fromJson(jsonData);
    } else {
      BotToast.showText(text: "Unable to delete employee.");
    }
  }
}