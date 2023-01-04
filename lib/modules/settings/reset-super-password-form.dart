import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/common/widget/password_request_dialog.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/shared/service/settings.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:password_manager/utils/size_config.dart';

class ResetSuperPasswordForm extends StatefulWidget {

  final Password? password;

  ResetSuperPasswordForm({this.password});

  @override
  _ResetSuperPasswordFormState createState() => _ResetSuperPasswordFormState();
}

class _ResetSuperPasswordFormState extends State<ResetSuperPasswordForm> {
  late PasswordService _passwordService;
  late SettingsService _settingsService;


  late TextEditingController _accountNameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late  bool _isSecret;
  bool _isPasswordVisible = false;

  bool saving = false;
  bool formValid = false;

  @override
  void initState() {
    super.initState();
    _passwordService = serviceLocator.get<PasswordService>();
    _settingsService = serviceLocator.get<SettingsService>();

    _accountNameController = new TextEditingController();
    _accountNameController.text = widget.password?.accountName ?? '';
    _emailController = new TextEditingController();
    _emailController.text = widget.password?.email ?? '';
    _usernameController = new TextEditingController();
    _usernameController.text = widget.password?.username ?? '';
    _passwordController = new TextEditingController();
    _passwordController.text = widget.password?.password ?? '';
    _isSecret = widget.password?.isSecret == true;

    validateForm();

    setupFormValidation();
  }

  void setupFormValidation() {
    _accountNameController.addListener(() { validateForm(); });
    _passwordController.addListener(() { validateForm(); });
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
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
            title: Text("Reset Super Password"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  void validateForm() {
    bool isFormValid = _accountNameController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty;
    if(isFormValid != formValid) {
      setState(() {
        formValid = isFormValid;
      });
    }
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 4 * SizeConfig.heightMultiplier,),
      child: TextField(
        controller: _accountNameController,
        decoration: InputDecoration(
          labelText: "Account Name *",
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
      padding: EdgeInsets.only(bottom: 4 * SizeConfig.heightMultiplier),
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
      padding: EdgeInsets.only(bottom: 4 * SizeConfig.heightMultiplier),
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
      padding: EdgeInsets.only(bottom: 2 * SizeConfig.heightMultiplier),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
            labelText: "Password *",
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
        onChanged: (bool? value) {
          setState(() {
            _isSecret = value ?? false;
          });
        },
        activeColor: Colors.lightBlue,
        checkColor: Colors.black45,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: formValid && !saving ? () async {
        if(_settingsService.getSettings().guardAddPassword) {
          bool canAdd = await showPasswordRequest(context: context);
          if(!canAdd) { return; }
        }
        savePassword();
      } : null,
      child: Text(saving ? "Saving..." : "Save Password"),
      style: ButtonStyle(
          enableFeedback: formValid
      ),
    );
  }

  void savePassword() async {
    setState(() { saving = true; });
    Password password = new Password(
        id: widget.password?.id,
        accountName: _accountNameController.text,
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        isSecret: _isSecret
    );

    Function saveFunction = widget.password?.id == null ? _passwordService.createPassword : _passwordService.updatePassword;

    try {
      await saveFunction(password);
      setState(() { saving = false; });
      Navigator.of(context).pop();
    } catch(err) {
      await showErrorDialog(context: context, body: "Saving password failed.  Please try again.");
      setState(() { saving = false; });
    }
  }
}
