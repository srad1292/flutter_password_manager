import 'package:flutter/material.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:password_manager/utils/size_config.dart';

class PasswordForm extends StatefulWidget {

  final Password password;

  PasswordForm({this.password});

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  PasswordService _passwordService;

  TextEditingController _accountNameController;
  TextEditingController _emailController;
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  bool _isSecret;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordService = serviceLocator.get<PasswordService>();

    _accountNameController = new TextEditingController();
    _accountNameController.text = widget?.password?.accountName ?? '';
    _emailController = new TextEditingController();
    _emailController.text = widget?.password?.email ?? '';
    _usernameController = new TextEditingController();
    _usernameController.text = widget?.password?.username ?? '';
    _passwordController = new TextEditingController();
    _passwordController.text = widget?.password?.password ?? '';
    _isSecret = widget?.password?.isSecret == true;
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
            title: Text((widget?.password?.id ?? null) == null ? 'Add Password' : 'Update Password'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
            child: _buildPasswordForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ..._buildFormFields(),
          _buildSubmitButton()
        ],
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      _buildAccountNameField(),
      _buildEmailField(),
      _buildUsernameField(),
      _buildPasswordField(),
      _buildIsSecretField()
    ];
  }

  Widget _buildAccountNameField() {
    //Todo : keyboard causing account name label to squish
    return Padding(
      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
      child: TextField(
        controller: _accountNameController,
        decoration: InputDecoration(
            labelText: "Account Name",
            hintText: "Type Account Name",
            // errorText: _passwordInputError.isEmpty ? null : _passwordInputError,
        ),
        keyboardType: TextInputType.text,
        // textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
      child: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "Type Email",
          // errorText: _passwordInputError.isEmpty ? null : _passwordInputError,
        ),
        keyboardType: TextInputType.text,
        // textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildUsernameField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
      child: TextField(
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: "Username",
          hintText: "Type Username",
          // errorText: _passwordInputError.isEmpty ? null : _passwordInputError,
        ),
        keyboardType: TextInputType.text,
        // textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
            labelText: "Password",
            hintText: "Type Password",
            // errorText: _passwordInputError.isEmpty ? null : _passwordInputError,
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
    );
  }

  Widget _buildIsSecretField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.only(left: 0),
        title: Text("Secret Account?"),
        controlAffinity: ListTileControlAffinity.leading,
        value: _isSecret,
        onChanged: (bool value) {
          setState(() {
            _isSecret = value;
          });
        },
        activeColor: Colors.lightBlue,
        checkColor: Colors.black45,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        Password password = new Password(
          id: widget?.password?.id,
          accountName: _accountNameController.text,
          email: _emailController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          isSecret: _isSecret
        );

        Function saveFunction = widget?.password?.id == null ? _passwordService.createPassword : _passwordService.updatePassword;

        await saveFunction(password);

        Navigator.of(context).pop();
      },
      child: Text("Save Password"),
    );
  }
}
