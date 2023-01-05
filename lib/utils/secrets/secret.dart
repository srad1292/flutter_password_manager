class Secret {

  final String secureKey;

  Secret({this.secureKey = ""});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(secureKey: jsonMap["secureKey"]);
  }
}