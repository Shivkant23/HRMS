import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrm/core/models/employee_list_response.dart';
import 'package:hrm/core/models/updated_employee.dart';
import 'package:hrm/core/providers/employee_provider.dart';
import 'package:hrm/core/services/service_locator.dart';
import 'package:hrm/core/view_models/employee_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({required this.employee, Key? key}) : super(key: key);
  Data employee;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isEditing = true;
  TextEditingController ageController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ageController.text = widget.employee.employeeAge.toString();
    salaryController.text = widget.employee.employeeSalary.toString();
  }

  Future<void> updateTheEmployee() async {
    EmployeeViewModel employeeViewModel = locator<EmployeeViewModel>();
    widget.employee.employeeAge = int.parse(ageController.text);
    widget.employee.employeeSalary = int.parse(salaryController.text);
    UpdatedEmployee? data = await employeeViewModel.updateTheEmployee(context, widget.employee);
    if(data != null){
      widget.employee.employeeAge = int.parse(data.age!);
      widget.employee.employeeName = data.name;
      widget.employee.employeeSalary = int.parse(data.salary!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder: (_, EmployeeProvider employeeProvider, __){
              return IconButton(
                icon: Icon(employeeProvider.getEditFlag ? Icons.edit : Icons.save, size: 30),
                onPressed: (){
                  if(!employeeProvider.getEditFlag){
                    updateTheEmployee();
                  }
                  employeeProvider.setEditFlag(!employeeProvider.getEditFlag);
                }, 
              );
            }
          ),
          
          const SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/default_user.png"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.employee.employeeName!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 46,
                              width: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purpleAccent,
                              ),
                              child: const Icon(Icons.email, color: Colors.white,),
                              alignment: Alignment.center,
                            ),
                            onTap: () => onMailToClicked(),
                          ),
                          // const Text('Email')
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 46,
                              width: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent,
                              ),
                              child: const Icon(Icons.call, color: Colors.white,),
                              alignment: Alignment.center,
                            ),
                            onTap: (){
                              _launchCaller();
                            },
                          ),
                          // const Text('Call')
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 46,
                              width: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(Icons.message_outlined, color: Colors.white,),
                              alignment: Alignment.center,
                            ),
                            onTap: (){_textMe();},
                          ),
                          // const Text('Message')
                        ],
                      ),
                    ],
                  ),
                  
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer(
                builder: (_, EmployeeProvider employeeProvider, __){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: ageController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Age',
                        ),
                        enabled: !employeeProvider.getEditFlag,
                        keyboardType: TextInputType.number,
                        inputFormatters: <FilteringTextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: salaryController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Salary',
                        ),
                        enabled: !employeeProvider.getEditFlag,
                        keyboardType: TextInputType.number,
                        inputFormatters: <FilteringTextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      )
                    ],
                  );
                }
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  void onMailToClicked() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'shivkant@gamil.com',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  _launchCaller() async {
    const url = "tel:1234567";   
    if (await canLaunch(url)) {
       await launch(url);
    } else {
      throw 'Could not launch $url';
    }   
  }

  _textMe() async {
    // Android
    const uri = 'sms:+39 348 060 888?body=hello%20there';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:0039-222-060-888?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

}