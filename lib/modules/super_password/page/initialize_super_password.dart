import 'package:flutter/material.dart';
import 'package:password_manager/modules/account_list/account_list_page.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:password_manager/utils/size_config.dart';

class InitializeSuperPassword extends StatefulWidget {
  @override
  _InitializeSuperPasswordState createState() => _InitializeSuperPasswordState();
}

class _InitializeSuperPasswordState extends State<InitializeSuperPassword> {

  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();
  String _passwordInputError = '';
  String _confirmPasswordInputError = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Welcome"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
                      child: Text(
                        'Please Setup a Super Password',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Type Password",
                          errorText: _passwordInputError.isEmpty ? null : _passwordInputError,
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            color: Colors.black45,
                            focusColor: Colors.black45,
                            disabledColor: Colors.black45,
                          )
                        ),
                        keyboardType: TextInputType.text,
                        // textInputAction: TextInputAction.done,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Type Password",
                            errorText: _confirmPasswordInputError.isEmpty ? null : _confirmPasswordInputError,
                            suffixIcon: IconButton(
                              icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                              color: Colors.black45,
                              focusColor: Colors.black45,
                              disabledColor: Colors.black45,
                            )
                        ),
                        keyboardType: TextInputType.text,
                        // textInputAction: TextInputAction.done,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // todo: some loading thing maybe
                        // disable the save button while it is trying to save

                        // save password
                        PasswordService passwordService = serviceLocator.get<PasswordService>();
                        Password passwordToSave = new Password(
                          isSuper: true,
                          accountName: "App Super Password",
                          password: _passwordController.text.trim()
                        );
                        Password? savedPassword = await passwordService.createPassword(passwordToSave);
                        if(savedPassword != null) {
                          // if it works, navigate
                          passwordService.superPassword = savedPassword;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return AccountListPage();
                            }),
                          );
                        }
                        else {
                          // if it fails, show a message saying password failed to save
                          print("Failed to create super password");
                        }

                      },
                      child: Text("Save Password"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
