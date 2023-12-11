import 'dart:async';

import 'package:flutter/material.dart';
import 'package:password_manager/common/widget/confirmation_dalog.dart';
import 'package:password_manager/common/widget/password_request_dialog.dart';
import 'package:password_manager/modules/import_export/pages/export_page.dart';
import 'package:password_manager/modules/import_export/services/import_service.dart';
import 'package:password_manager/modules/settings/password_action.dart';
import 'package:password_manager/modules/settings/settings_page.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/modules/shared/service/pm-permission-service.dart';
import 'package:password_manager/modules/shared/service/settings.dart';
import 'package:password_manager/styling/colors.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:password_manager/utils/size_config.dart';

import '../password_form.dart';

class AccountListPage extends StatefulWidget {
  @override
  _AccountListPageState createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  late PasswordService _passwordService;
  List<Password> _passwords = [];
  bool passwordsExist = false;
  late TextEditingController _passwordSearchController;
  late SettingsService _settingsService;
  String _passwordSearchText = '';
  bool _showHidden = false;
  bool _loading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _settingsService = serviceLocator.get<SettingsService>();
    _passwordService = serviceLocator.get<PasswordService>();
    _passwordSearchController = new TextEditingController();
    _passwordSearchController.addListener(_setupPasswordSearch);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPasswords("").then((_) {
        setState(() {
          _loading = false;
          passwordsExist = _passwords.isNotEmpty;
        });
      });
    });
  }

  @override
  void dispose() {
    _passwordSearchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _setupPasswordSearch() {
    if(_passwordSearchController.text == _passwordSearchText) {
      return;
    }

    setState(() {
      _passwordSearchText = _passwordSearchController.text;
    });

    if(_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _passwordSearchText = _passwordSearchController.text;
        });
        _loadPasswords(_passwordSearchText);
      }
    });
  }

  Future<void> _loadPasswords(String accountSearch) async {
    try {
      List<Password> dbPasswords = await this._passwordService.getPasswordsFromPersistence(
        showSecret: _showHidden,
        accountSearch: accountSearch
      );
      dbPasswords.forEach((element) {print(element.toString());});
      if(mounted) {
        setState(() {
          _passwords = dbPasswords;
        });
      }
    } catch(error) {
      print("error loading passwords");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Passwords",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 3 * SizeConfig.textMultiplier,
              ),
            )
          ),
          drawer: _buildAccountListDrawer(),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: _loading ? _buildScreenLoading() : _buildPasswordScreen()
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 9 * SizeConfig.widthMultiplier,
            ),
            onPressed: () async {
              bool created = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return PasswordForm();
                }),
              );

              this._loadPasswords(_passwordSearchText).then((_) {
                if(created && !passwordsExist) {
                  setState(() {
                    passwordsExist = true;
                  });
                }
              });
            },
          ),
        )
      )
    );
  }

  Widget _buildAccountListDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: Text("Menu", style: Theme.of(context).textTheme.headline6,),
            tileColor: appBarLight,
          ),
          ListTile(
            title: const Text('Import'),
            trailing: Icon(Icons.download),
            onTap: () async {

              if(_settingsService.getSettings().guardImportPasswords) {
                bool confirmed = await showPasswordRequest(context: context);
                if(!confirmed) { return; }
              }
              PmPermissionService permissionService = new PmPermissionService();
              bool fileAccess = await permissionService.checkStoragePermission(context);
              if(!fileAccess) { return; }
              ImportService importService = new ImportService(context);
              bool imported = await importService.importData();
              if(imported) {
                Navigator.of(context).pop();
                _passwordSearchController.text = '';
                _loadPasswords('').then((_) {
                  setState(() {
                    passwordsExist = _passwords.isNotEmpty;
                  });
                });
              }
            },
          ),
          Divider(thickness: 2,),
          ListTile(
            title: const Text('Export'),
            trailing: Icon(Icons.publish),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return ExportDataPage();
                  })
              );
            },
          ),
          Divider(thickness: 2,),
          ListTile(
            title: const Text('Settings'),
            trailing: Icon(Icons.settings),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return SettingsPage();
                })
              );
              if(_passwordService.hasResetSuperPassword) {
                _passwordService.hasResetSuperPassword = false;
                await this._loadPasswords(_passwordSearchText);
              }
            },
          ),
          Divider(thickness: 2,),
        ],
      ),
    );
  }

  Widget _buildScreenLoading() {
    return Center(
      child: Column(
        children: [
          Text("Loading..."),
          CircularProgressIndicator()
        ]
      )
    );
  }
  
  Widget _buildPasswordScreen() {
    if(!passwordsExist) {
      return _buildEmptyListScreen();
    } else {
      return _buildHasPasswordScreen();
    }
  }
  
  Widget _buildEmptyListScreen() {
    return Center(
      child: Text("No passwords created."),
    );
  }
  
  Widget _buildHasPasswordScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 2,
          child: _buildPasswordSearch()
        ),
        Flexible(
          flex: 2,
          child: _buildShowHiddenSwitch()
        ),
        _passwords.isEmpty ? Flexible(
          flex: 1,
          child: _buildNoMatchingPasswords()
        ) : Container(),
        Flexible(
            flex: 8,
            child: _buildPasswordList()
        ),
        Flexible(
          child: Container()
        )
      ],
    );
  }
  
  Widget _buildPasswordSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.5 * SizeConfig.widthMultiplier),
      child: TextField(
        controller: _passwordSearchController,
        decoration: InputDecoration(
          hintText: "Search Passwords",
          suffixIcon: Icon(Icons.search, color: Colors.black45),
        ),
      ),
    );
  }

  Widget _buildShowHiddenSwitch() {
    return Padding(
      padding: EdgeInsets.only(left: 3.5 * SizeConfig.widthMultiplier),
      child: Row(
        children: [
          Text(
              "Show Secret Passwords?",
              style: Theme.of(context).textTheme.subtitle2
          ),
          Switch(
            value: _showHidden,
            onChanged: (newValue) async {
              if(_settingsService.getSettings().guardShowSecretPasswords && newValue == true) {
                bool confirmed = await showPasswordRequest(context: context);
                if(!confirmed) {
                  setState(() {
                    _showHidden = false;
                  });
                  return;
                }
              }
              setState(() {
                _showHidden = newValue;
              });
              this._loadPasswords(_passwordSearchText);
            },
            inactiveThumbColor: Theme.of(context).toggleableActiveColor,
            inactiveTrackColor: Colors.black12,
          ),
        ],
      ),
    );
  }

  Widget _buildNoMatchingPasswords() {
    return Text("No passwords found");
  }
  
  Widget _buildPasswordList() {
    return ListView.separated(
      itemCount: _passwords.length,
      itemBuilder: (context, index) {
        Password password = _passwords[index];
        String subtitle = _getEmailOrUsername(password);

        return ListTile(
          title: Text(password.accountName),
          subtitle: Text(subtitle),
          trailing: password.isSecret ? Icon(Icons.visibility_off) : null,
          onTap: () {
            _showPasswordPressedDialog(password);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 2.0,
        );
      },
    );
  }

  String _getEmailOrUsername(Password password) {
    String subtitle = (password.email).isEmpty ? password.username : password.email;
    return subtitle;
  }

  void _showPasswordPressedDialog(Password password) async {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var containerWidthMultiplier = isPortrait ?  0.9 : 0.45;

    SimpleDialog passwordDialog = new SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(6, 24, 0, 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5 * SizeConfig.widthMultiplier)
        ),
      ),
      title: Column(
        children: [
          Text(
            password.accountName,
            textAlign: TextAlign.center,
          ),
          Text(
            _getEmailOrUsername(password),
            style: Theme.of(context).textTheme.subtitle1
          )
        ],
      ),
      children: <Widget>[
        Container(width: containerWidthMultiplier * MediaQuery.of(context).size.width),
        SimpleDialogOption(
          onPressed: () async {
            if(_settingsService.getSettings().guardViewPassword == true) {
              bool confirmed = await showPasswordRequest(context: context);
              if(!confirmed) {
                return;
              }
            }

            Navigator.of(context).pop(PasswordAction.view);
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(Icons.read_more),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("View Details"),
                )
              ],
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(PasswordAction.edit);
              },
              child: Row(
                children: [
                  Icon(Icons.edit),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Edit Password"),
                  )
                ],
              )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 1.2 * SizeConfig.heightMultiplier),
          child: SimpleDialogOption(
              onPressed: () async {
                bool confirmDelete = await showConfirmationDialog(context: context, body: "Delete ${password.accountName}?");
                if(!confirmDelete) { return; }

                if(_settingsService.getSettings().guardDeletePassword == true) {
                  bool confirmPassword = await showPasswordRequest(context: context);
                  if(!confirmPassword) { return; }
                }

                Navigator.of(context).pop(PasswordAction.delete);
              },
              child: Row(
                children: [
                  Icon(Icons.delete_forever),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Delete Password"),
                  )
                ],
              )
          ),
        ),
      ],
    );

    PasswordAction? result = await showDialog<PasswordAction>(
      context: context,
      builder: (_) => passwordDialog
    );

    if(result == null) return;

    if(result == PasswordAction.view) {
      _showPasswordDetailsDialog(password);
    } else if(result == PasswordAction.edit) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return PasswordForm(password: new Password.clone(password));
        }),
      );
      this._loadPasswords(_passwordSearchText);
    } else if(result == PasswordAction.delete) {
      await _passwordService.deletePassword(passwordID: password.id ?? -1);
      _passwordSearchController.text = "";
      _loadPasswords(_passwordSearchText).then((_) {
        setState(() {
          passwordsExist = _passwords.isNotEmpty;
        });
      });
    }
  }

  void _showPasswordDetailsDialog(Password password) async {
    SimpleDialog passwordDetailsDialog = new SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(24, 24, 0, 16),
      titlePadding: EdgeInsets.fromLTRB(32, 24, 32, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(5 * SizeConfig.widthMultiplier)
        ),
      ),
      title: Text(
        password.accountName,
        textAlign: TextAlign.center,
      ),
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
                style: Theme.of(context).textTheme.subtitle2
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.5 * SizeConfig.heightMultiplier),
                child: Text((password.email).isEmpty ? '- - -' : password.email),
              )
            ]
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Username",
                style: Theme.of(context).textTheme.subtitle2
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.5 * SizeConfig.heightMultiplier),
                child: Text((password.username).isEmpty ? '- - -' : password.username),
              )
            ]
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Password",
                style: Theme.of(context).textTheme.subtitle2
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.5 * SizeConfig.heightMultiplier),
                child: Text(password.password),
              )
            ]
          ),
        ),
      ],
    );

    await showDialog<void>(
        context: context,
        builder: (_) => passwordDetailsDialog
    );
  }
}
