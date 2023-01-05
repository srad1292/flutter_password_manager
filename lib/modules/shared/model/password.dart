class Password {
  int? id;
  late String accountName;
  late String email;
  late String username;
  late String password;
  late bool isSecret;

  Password({
    this.id, this.accountName = '', this.email = '', this.username = '',
    this.password = '', this.isSecret=false,
  });

  Password.clone(Password password) {
    this.id = password.id;
    this.accountName = password.accountName;
    this.email = password.email;
    this.username = password.username;
    this.password = password.password;
    this.isSecret = password.isSecret;
  }

  Map<String, dynamic> toPersistence() =>
  {
    'id': this.id,
    'account_name': this.accountName,
    'email': this.email,
    'username': this.username,
    'password': this.password,
    'is_secret': this.isSecret == true ? 1 : 0,
  };

  Map<String, dynamic> toJson() =>
  {
    'id': this.id,
    'accountName': this.accountName,
    'email': this.email,
    'username': this.username,
    'password': this.password,
    'isSecret': this.isSecret,
  };

  factory Password.fromPersistence(Map<String, dynamic> json) {
    return Password(
      id: json['id'],
      accountName: json['account_name'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      isSecret: json['is_secret'] == 1 ? true : false,
    );
  }

  factory Password.fromJson(Map<String, dynamic> json) {
    return Password(
      id: json['id'],
      accountName: json['accountName'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      isSecret: json['isSecret'],
    );
  }

  @override
  String toString() {
    return '''
    (
      id: ${this.id}, 
      accountName: ${this.accountName}, 
      email: ${this.email}, 
      username: ${this.username}, 
      password: ${this.password}, 
      isSecret: ${this.isSecret}, 
    )''';
  }
}