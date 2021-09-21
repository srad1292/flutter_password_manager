class Password {
  int id;
  String accountName;
  String email;
  String username;
  String password;
  bool isSecret;

  Password({this.id, this.accountName = '', this.email = '', this.username = '', this.password = '', this.isSecret=false});

  Map<String, dynamic> toPersistence() =>
  {
    'id': this.id,
    'account_name': this.accountName,
    'email': this.email,
    'username': this.username,
    'password': this.password,
    'is_active': this.isSecret == true ? 1 : 0,
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

  @override
  String toString() {
    return '''
    (
      accountName: ${this.accountName}, 
      email: ${this.email}, 
      username: ${this.username}, 
      password: ${this.password}, 
      isSecret: ${this.isSecret}, 
    )''';
  }
}