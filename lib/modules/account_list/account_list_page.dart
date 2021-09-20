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
          ),
        )
      ) 
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
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          color: Colors.black45,
          focusColor: Colors.black45,
          disabledColor: Colors.black45,
        )
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
