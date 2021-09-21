import 'package:flutter/material.dart';
import 'package:password_manager/styling/colors.dart';
import 'package:password_manager/utils/size_config.dart';

class AccountListPage extends StatefulWidget {
  @override
  _AccountListPageState createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final items = List<String>.generate(20, (i) => "Item $i");
  // final items = List<String>.generate(0, (i) => "Item $i");
  TextEditingController _passwordSearchController;
  bool _showHidden = false;

  @override
  void initState() {
    super.initState();

    _passwordSearchController = new TextEditingController();
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
            title: Text("Passwords")
          ),
          drawer: _buildAccountListDrawer(),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: _buildPasswordScreen()
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 9 * SizeConfig.widthMultiplier,
            ),
            onPressed: () {},
          ),
        )
      ) 
    );
  }

  Widget _buildAccountListDrawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
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
  
  Widget _buildPasswordScreen() {
    if((items ?? []).length == 0) {
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
    return TextField(
      controller: _passwordSearchController,
      decoration: InputDecoration(
        hintText: "Search Application",
        suffixIcon: Icon(Icons.search, color: Colors.black45),
      ),
    );
  }

  Widget _buildShowHiddenSwitch() {
    return Padding(
      padding: EdgeInsets.only(left: 3.5 * SizeConfig.widthMultiplier),
      child: Row(
        children: [
          Text(
              "Show Hidden?",
              style: Theme.of(context).textTheme.subtitle2
          ),
          Switch(
            value: _showHidden,
            onChanged: (newValue) {
              setState(() {
                _showHidden = newValue;
              });
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
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          subtitle: Text("smr1292@gmail.com"),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 2.0,
        );
      },
    );
  }
}
