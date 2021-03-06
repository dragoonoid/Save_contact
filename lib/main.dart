import 'package:flutter/material.dart';
import 'package:sqlite_intro/utils/database_helper.dart';

import 'models/contact.dart';

const color = Color(0xff486579);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact Saver',
      theme: ThemeData(
        primaryColor: color,
      ),
      home: const MyHomePage(title: 'Contact Saver'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  List<Contact> _contacts = [];
  late DatabaseHelper _dbHelper;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper=DatabaseHelper.instance;
    });
    _refreshContactList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(color: color),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_form(), _list()],
          ),
        ),
      ),
    );
  }

  Contact _contact = Contact();
  _form() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              onSaved: (val) {
                if (val != null) {
                  setState(() {
                    _contact.name = val;
                  });
                }
              },
              validator: (val) {
                if (val == null || val.length == 0) {
                  return 'This field is required.';
                }
                else if(val!=null){
                  for(int i=0;i<_contacts.length;i++){
                    if(_contacts[i].name==val){
                      return 'Name already Present';
                    }
                  }
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
              ),
              onSaved: (val) {
                if (val != null) {
                  setState(() {
                    _contact.number = val;
                  });
                }
              },
              validator: (val) {
                if (val == null || val.length < 10) {
                  return 'Please enter a correct mobile number!';
                }
                return null;
              },
            ),
            Container(
              margin: const EdgeInsets.all(8),
              color: Colors.white,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(color)),
                child: const Text('Submit'),
                onPressed: () async {
                  var state = _formKey.currentState;
                  if (state?.validate() == true) {
                    state?.save();
                    // setState(() {
                    //   _contacts.insert(0,Contact(id:null,name:_contact.name,number: _contact.number));
                    // });
                      await _dbHelper.insertContact(_contact);
                      await _refreshContactList();
                    if (_contact.name != null && _contact.number != null) {
                      FocusScope.of(context).unfocus();
                    }
                    state?.reset();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  _list() {
    return Expanded(
      child: Card(
        margin:const EdgeInsets.fromLTRB(10, 5, 20, 0),
        child: ListView.builder(
          padding:const EdgeInsets.all(8),
          itemBuilder: ((context, i) {
            return Column(
              children: [
                ListTile(
                  title: Text(_contacts[i].name!.toUpperCase()),
                  subtitle: Text(_contacts[i].number!),
                  leading: const Icon(
                    Icons.contact_phone,
                    color: color,
                    size: 40,
                  ),
                ),
                const Divider(
                  height: 5,
                )
              ],
            );
          }),
          itemCount: _contacts.length,
        ),
      ),
    );
  }

  _refreshContactList() async{
    List<Contact> x=await _dbHelper.fetchContacts();
    setState(() {
      _contacts=x;
    });
  }
}
