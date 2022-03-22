class UpdatedEmplyeeResponse {
  String? status;
  UpdatedEmployee? data;
  String? message;

  UpdatedEmplyeeResponse({this.status, this.data, this.message});

  UpdatedEmplyeeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UpdatedEmployee.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class UpdatedEmployee {
  String? name;
  String? salary;
  String? age;

  UpdatedEmployee({this.name, this.salary, this.age});

  UpdatedEmployee.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    salary = json['salary'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['salary'] = this.salary;
    data['age'] = this.age;
    return data;
  }
}
