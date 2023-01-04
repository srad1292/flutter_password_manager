class SuperPassword {
  int? id;
  late String password;

  SuperPassword({
    this.id, this.password = '',
  });

  SuperPassword.clone(SuperPassword password) {
    this.id = password.id;
    this.password = password.password;
  }

  Map<String, dynamic> toPersistence() =>
  {
    'id': this.id,
    'password': this.password,
  };

  factory SuperPassword.fromPersistence(Map<String, dynamic> json) {
    return SuperPassword(
      id: json['id'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return '''
    (
      id: ${this.id}, 
      password: ${this.password}, 
    )''';
  }
}