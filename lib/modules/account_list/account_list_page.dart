import 'package:flutter/material.dart';
import 'package:password_manager/modules/settings/password_action.dart';
import 'package:password_manager/modules/shared/model/password.dart';
import 'package:password_manager/modules/shared/service/password.dart';
import 'package:password_manager/utils/service_locator.dart';
import 'package:password_manager/utils/size_config.dart';

import '../password_form.dart';

class AccountListPage extends StatefulWidget {
  @override
  _AccountListPageState createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  PasswordService _passwordService;
  List<Password> _passwords;
  TextEditingController _passwordSearchController;
  bool _showHidden = false;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _passwordService = serviceLocator.get<PasswordService>();
    _passwordSearchController = new TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPasswords("").then((_) {
        setState(() {
          _loading = false;
        });
      });
    });
  }

  Future<void> _loadPasswords(String accountSearch) async {
    try {
      List<Password> dbPasswords = await this._passwordService.getPasswordsFromPersistence(
        showSecret: _showHidden,
        accountSearch: accountSearch
      );
      setState(() {
        _passwords = dbPasswords;
      });
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
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Passwords")
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
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return PasswordForm();
                }),
              );

              await this._loadPasswords(_passwordSearchController.text ?? '');
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
            tileColor: Colors.lightBlueAccent,
          ),
          ListTile(
            title: const Text('Import'),
            trailing: Icon(Icons.vertical_align_top),
            onTap: () {
              //TODO Add import functionality
              // Note this makes me wonder about what if you import with duplicate ids
              // should the import overwrite existing data.  I think in my head I decided that
              // earlier but I need to think about it.
              print("Import coming soon");
            },
          ),
          Divider(thickness: 2,),
          ListTile(
            title: const Text('Export'),
            trailing: Icon(Icons.vertical_align_bottom),
            onTap: () {
              //TODO Add export functionality
              print("Export coming soon");
            },
          ),
          Divider(thickness: 2,),
          ListTile(
            title: const Text('Settings'),
            trailing: Icon(Icons.settings),
            onTap: () {
              //TODO Link to user settings
              print("User settings coming soon");
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
    if((_passwords ?? []).length == 0) {
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
          hintText: "Search Application",
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
            onChanged: (newValue) {
              setState(() {
                _showHidden = newValue;
              });
              this._loadPasswords(_passwordSearchController.text);
            },
            activeColor: Colors.blueAccent,
            activeTrackColor: Colors.lightBlueAccent,
            inactiveThumbColor: Colors.blueAccent,
            inactiveTrackColor: Colors.black12,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPasswordList() {
    return ListView.separated(
      itemCount: _passwords.length,
      itemBuilder: (context, index) {
        Password password = _passwords[index];
        String subtitle = (password.email ?? '').isEmpty ? password.username : password.email;

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

  void _showPasswordPressedDialog(Password password) async {

    SimpleDialog passwordDialog = new SimpleDialog(
      title: Text(password.accountName),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(PasswordAction.view);
          },
          child: Row(
            children: [
              Icon(Icons.read_more),
              Text("View Details")
            ],
          )
        ),
        SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(PasswordAction.edit);
            },
            child: Row(
              children: [
                Icon(Icons.edit),
                Text("Edit Password")
              ],
            )
        ),
        SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(PasswordAction.delete);
            },
            child: Row(
              children: [
                Icon(Icons.delete_forever),
                Text("Delete Password")
              ],
            )
        ),
      ],
    );

    PasswordAction result = await showDialog<PasswordAction>(
      context: context,
      builder: (_) => passwordDialog
    );

    if(result == null) return;

    if(result == PasswordAction.view) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("View details coming soon"))
      );
    } else if(result == PasswordAction.edit) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return PasswordForm(password: new Password.clone(password));
        }),
      );
      this._loadPasswords(_passwordSearchController.text);
    } else if(result == PasswordAction.delete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete coming soon"))
      );
    }
  }
}
