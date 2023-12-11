class Password {
  int? id;
  late String accountName;
  late String email;
  late String username;
  late String password;
  late bool isSecret;
  late String createdAt;
  late String updatedAt;

  Password({
    this.id, this.accountName = '', this.email = '', this.username = '',
    this.password = '', this.createdAt = '', this.updatedAt = '', this.isSecret=false,
  });

  Password.clone(Password password) {
    this.id = password.id;
    this.accountName = password.accountName;
    this.email = password.email;
    this.username = password.username;
    this.password = password.password;
    this.isSecret = password.isSecret;
    this.createdAt = password.createdAt;
    this.updatedAt = password.updatedAt;
  }

  Map<String, dynamic> toPersistence() =>
  {
    'id': this.id,
    'account_name': this.accountName,
    'email': this.email,
    'username': this.username,
    'password': this.password,
    'is_secret': this.isSecret == true ? 1 : 0,
    'created_at': this.createdAt,
    'updated_at': this.updatedAt,
  };

  Map<String, dynamic> toJson() =>
  {
    'id': this.id,
    'accountName': this.accountName,
    'email': this.email,
    'username': this.username,
    'password': this.password,
    'isSecret': this.isSecret,
    'created_at': this.createdAt,
    'updated_at': this.updatedAt,
  };

  factory Password.fromPersistence(Map<String, dynamic> json) {
    return Password(
      id: json['id'],
      accountName: json['account_name'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      isSecret: json['is_secret'] == 1 ? true : false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
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
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
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
      createdAt: ${this.createdAt},
      updatedAt: ${this.updatedAt},
    )''';
  }
}