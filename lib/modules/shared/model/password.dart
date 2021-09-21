class Password {
  int id;
  String accountName;
  String email;
  String username;
  String password;
  bool isSecret;
  bool isSuper;

  Password({
    this.id, this.accountName = '', this.email = '', this.username = '',
    this.password = '', this.isSecret=false, this.isSuper=false
  });

  Map<String, dynamic> toPersistence() =>
  {
    'id': this.id,
    'account_name': this.accountName,
    'email': this.email,
    'username': this.username,
    'password': this.password,
    'is_secret': this.isSecret == true ? 1 : 0,
    'is_super': this.isSuper == true ? 1 : 0,
  };

  factory Password.fromPersistence(Map<String, dynamic> json) {
    return Password(
      id: json['id'],
      accountName: json['account_name'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      isSecret: json['is_secret'] == 1 ? true : false,
      isSuper: json['is_super'] == 1 ? true : false,
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
      isSuper: ${this.isSecret}, 
    )''';
  }
}