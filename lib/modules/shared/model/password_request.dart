import 'dart:convert';

class PasswordRequest {
  late String requestName;
  late bool shouldRequest;
  
  PasswordRequest({required String requestName, bool shouldRequest = false}) {
    this.requestName = requestName;
    this.shouldRequest = shouldRequest;
  }

  PasswordRequest.fromPersistence(Map<String, dynamic> record) {
    this.requestName = record['request_name'];
    this.shouldRequest = record['should_request'];
  }

  Map<String, dynamic> toPersistence() => {
    'request_name': this.requestName,
    'should_request': this.shouldRequest
  };

  void setShouldRequest(bool value) {
    this.shouldRequest = value;
  }
  
  @override
  String toString() {
    return jsonEncode(this);
  }
  
}