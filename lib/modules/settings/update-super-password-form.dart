import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:password_manager/common/widget/password_request_dialog.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/super_password/page/super_password.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:password_manager/utils/size_config.dart';

class UpdateSuperPasswordForm extends StatefulWidget {

  UpdateSuperPasswordForm();

  @override
  _UpdateSuperPasswordFormState createState() => _UpdateSuperPasswordFormState();
}

class _UpdateSuperPasswordFormState extends State<UpdateSuperPasswordForm> {
  late PasswordService _passwordService;

  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;



  bool _newVisible = false;
  bool _confirmVisible = false;


  bool saving = false;
  bool formValid = false;

  @override
  void initState() {
    super.initState();
    _passwordService = serviceLocator.get<PasswordService>();

    _newPasswordController = new TextEditingController();
    _newPasswordController.text = '';
    _confirmPasswordController = new TextEditingController();
    _confirmPasswordController.text = '';


    validateForm();

    setupFormValidation();
  }

  void setupFormValidation() {
    _newPasswordController.addListener(() { validateForm(); });
    _confirmPasswordController.addListener(() { validateForm(); });

  }

  @override
  void dispose() {
    _newPasswordController.dispose();
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
            title: Text("Update Super Password"),
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
    bool isFormValid = _newPasswordController.text.trim().isNotEmpty &&
        _confirmPasswordController.text.trim().isNotEmpty && _newPasswordController.text.trim() == _confirmPasswordController.text.trim();
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
      _buildNewPasswordField(),
      _buildConfirmPasswordField(),
    ];
  }


  Widget _buildNewPasswordField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4 * SizeConfig.heightMultiplier),
      child: TextField(
        controller: _newPasswordController,
        obscureText: !_newVisible,
        decoration: InputDecoration(
            labelText: "New Super Password *",
            hintText: "Type New Password",
            // errorText: _passwordInputError.isEmpty ? null : _passwordInputError,
            suffixIcon: IconButton(
              icon: Icon(_newVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _newVisible = !_newVisible;
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

  Widget _buildConfirmPasswordField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 5 * SizeConfig.heightMultiplier),
      child: TextField(
        controller: _confirmPasswordController,
        obscureText: !_confirmVisible,
        decoration: InputDecoration(
            labelText: "Confirm New Password *",
            hintText: "Type New Password",
            // errorText: _passwordInputError.isEmpty ? null : _passwordInputError,
            suffixIcon: IconButton(
              icon: Icon(_confirmVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _confirmVisible = !_confirmVisible;
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


  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: formValid && !saving ? () async {
        bool canAdd = await showPasswordRequest(context: context);
        if(!canAdd) { return; }

        saveSuperPassword();
      } : null,
      child: Text(saving ? "Updating..." : "Update Password"),
      style: ButtonStyle(
        enableFeedback: formValid
      ),
    );
  }

  void saveSuperPassword() async {
    setState(() { saving = true; });
    SuperPassword password = new SuperPassword(
        password: _newPasswordController.text.trim(),
    );

    Function saveFunction = _passwordService.updateSuperPassword;

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
