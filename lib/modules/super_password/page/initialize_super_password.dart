import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/modules/account_list/account_list_page.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/super_password/page/super_password.dart';
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
  bool _isSaving = false;
  bool _formValid = false;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {validateForm();});
    _confirmPasswordController.addListener(() {validateForm();});
  }

  void validateForm() {
    bool isFormValid = _passwordController.text.trim().isNotEmpty && _confirmPasswordController.text.trim().isNotEmpty &&
      _passwordController.text.trim() == _confirmPasswordController.text.trim();
    if(isFormValid != _formValid) {
      setState(() {
        _formValid = isFormValid;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            title: Text("Create Super Password"),
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
                      padding: EdgeInsets.only(bottom: 1.5 * SizeConfig.heightMultiplier),
                      child: Text(
                        'Please Setup a Super Password',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4 * SizeConfig.heightMultiplier),
                      child: Text(
                        'This super password will be used for confirmation when performing protected actions.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
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
                      padding: EdgeInsets.only(bottom: 4 * SizeConfig.heightMultiplier),
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
                      onPressed: _isSaving || !_formValid ? null : () async {
                        // todo: some loading thing maybe
                        if(_isSaving || !_formValid) { return; }

                        // save password
                        _isSaving = true;
                        PasswordService passwordService = serviceLocator.get<PasswordService>();
                        SuperPassword passwordToSave = new SuperPassword(
                          password: _passwordController.text.trim()
                        );
                        SuperPassword? savedPassword = await passwordService.createSuperPassword(passwordToSave);
                        _isSaving = false;
                        if(savedPassword != null) {
                          passwordService.superPassword = SuperPassword.clone(savedPassword);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return AccountListPage();
                            }),
                          );
                        }
                        else {
                          showErrorDialog(context: context, body: "Super Password failed to save. Try again");
                        }

                      },
                      child: Text(_isSaving ? "Saving..." : "Save Password"),
                      style: ButtonStyle(
                          enableFeedback: _formValid
                      ),
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
