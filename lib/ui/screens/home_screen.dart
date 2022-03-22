
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrm/core/models/employee_list_response.dart';
import 'package:hrm/core/models/updated_employee.dart';
import 'package:hrm/core/providers/employee_provider.dart';
import 'package:hrm/core/services/service_locator.dart';
import 'package:hrm/core/view_models/employee_view_model.dart';
import 'package:hrm/ui/screens/detail_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Data> employeeList = [];
  TextEditingController textEditingController = TextEditingController();
  bool isFocused = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  final focusNode = FocusNode();
  EmployeeViewModel employeeViewModel = locator<EmployeeViewModel>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getListOfEmployees() async {
    employeeList = await employeeViewModel.listOfEmployee(context);
    print(employeeList);
  }

  Future<void> deleteTheEmployee(Data employee) async {
    await employeeViewModel.deleteEmployee(context, employee);
    Timer(const Duration(seconds: 1), () => print("object"));
  }

  Future<void> searchEmployee(String query) async {
    EmployeeProvider employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    if(query.isNotEmpty){
      List<Data> list = [];
      for (var item in employeeList) {
        if(item.employeeName!.toLowerCase().contains(query))list.add(item);
      }
      employeeProvider.setListOfEmployees(list);
    }else{
      employeeProvider.setListOfEmployees(employeeList);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 35,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          textEditingController.text = "";
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8),
                      hintText: 'Search',
                      border: InputBorder.none
                    ),
                    onChanged: (query)async{
                      await searchEmployee(query);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ),
      body: FutureBuilder(
        future: getListOfEmployees(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done || snapshot.hasData){
          return Consumer(
            builder: (BuildContext context, EmployeeProvider employeeProvider, Widget? child) {
              return GestureDetector(
                onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
                child: ListView.builder(
                  itemCount: employeeProvider.getListOfEmployees.length,
                  itemBuilder: (BuildContext context, int index){
                    return Dismissible(
                      onDismissed: (direction) {
                        deleteTheEmployee(employeeProvider.getListOfEmployees[index]);       
                      },
                      key: Key(employeeProvider.getListOfEmployees[index].id.toString()),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailScreen(employee: employeeProvider.getListOfEmployees[index],)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              // employeeList[index].profileImage!.isNotEmpty ? NetworkImage(employeeList[index].profileImage!) : const AssetImage("assets/default_user.png"),
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage("assets/default_user.png"),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${employeeProvider.getListOfEmployees[index].employeeName}'),
                                  Row(
                                    children: [
                                      // const Icon(Icons.account_circle_outlined),
                                      Text('Id - ${employeeProvider.getListOfEmployees[index].id}'),
                                    ],
                                  )
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Age: ${employeeProvider.getListOfEmployees[index].employeeAge}'),
                                  Row(
                                    children: [
                                      const Icon(Icons.money_off_csred_sharp, color: Colors.black45,),
                                      Text('${employeeProvider.getListOfEmployees[index].employeeSalary}',
                                        style: const TextStyle(fontSize: 18, color: Colors.black) 
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ),
              );
            }
          );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addNewEmployee(),
      ),
    );
  }

  addNewEmployee() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          title: const Center(child: Text("Add New Employee")),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                keyboardType: TextInputType.text,
                inputFormatters: <FilteringTextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <FilteringTextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salary',
                ),
                keyboardType: TextInputType.number, 
                inputFormatters: <FilteringTextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: ()async{
                      EmployeeViewModel employeeViewModel = locator<EmployeeViewModel>();
                      UpdatedEmployee employee = UpdatedEmployee(
                        name: nameController.text, 
                        age: ageController.text, 
                        salary: salaryController.text
                      );
                      UpdatedEmployee? data = await employeeViewModel.createEmployee(context, employee);
                      if(data != null){
                        nameController.text = "";
                        ageController.text = "";
                        salaryController.text = "";
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      });
  }

}