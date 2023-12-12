import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/common/widget/password_request_dialog.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/shared/service/settings.dart';
import 'package:password_manager/utils/date_functions.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:password_manager/utils/size_config.dart';

class PasswordForm extends StatefulWidget {

  final Password? password;

  PasswordForm({this.password});

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  late PasswordService _passwordService;
  late SettingsService _settingsService;


  late TextEditingController _accountNameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late  bool _isSecret;
  bool _isPasswordVisible = false;
  late bool _isCreateForm;

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

    _isCreateForm = widget.password?.id == null;

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
            title: Text((widget.password?.id ?? null) == null ? 'Add Password' : 'Update Password'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
            child: _buildPasswordForm(),
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

  Widget _buildPasswordForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          if(!_isCreateForm)
            _buildLastUpdatedDisplay(),
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
              onPressed: () async {
                if(!_isCreateForm && _settingsService.getSettings().guardViewPassword) {
                    bool canViewPassword = await showPasswordRequest(context: context);
                    if(!canViewPassword) { return; }
                }
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

  Widget _buildLastUpdatedDisplay() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4 * SizeConfig.heightMultiplier),
      child: Text("Last Updated: ${DateFunctions.iso8601ToDisplay(widget.password?.updatedAt ?? '')}"),
    );
  }

  void savePassword() async {
    setState(() { saving = true; });
    var now = DateTime.now().toUtc();
    String isoDate = now.toIso8601String();
    Password password = new Password(
        id: widget.password?.id,
        accountName: _accountNameController.text,
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        isSecret: _isSecret,
        createdAt: _isCreateForm ? isoDate : (widget.password?.createdAt ?? isoDate),
        updatedAt: isoDate,
    );

    Function saveFunction = _isCreateForm ? _passwordService.createPassword : _passwordService.updatePassword;

    try {
      await saveFunction(password);
      setState(() { saving = false; });
      Navigator.of(context).pop(true);
    } catch(err) {
      await showErrorDialog(context: context, body: "Saving password failed.  Please try again.");
      setState(() { saving = false; });
    }
  }
}
