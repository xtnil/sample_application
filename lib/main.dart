
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sample/address.dart';

late Box box;
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  box = await Hive.openBox('Box');
  Hive.registerAdapter(AddressAdapter());
  // box.put('address',Address(id: "20101104046", addresses: [{
  //                           "bname":"Kolkata Branch",
  //                           "bcode":"005",
  //                           "address":"2687 BBD Road Kolkata 700254",
  //                           "prefix":"KOL"
  //                         }]));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  var bcode = TextEditingController();
  var bname = TextEditingController();
  var address = TextEditingController();
  var prefix = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var addressall = box.get("address");
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample app"),
      ),
      body: addressall==null?(
        Center(child: Text(("Nothing added to add new click on the + button bellow")),)
      ):(
        ListView.builder(
                itemCount: addressall.addresses.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      height: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                           ListTile(
                            leading: Icon(Icons.album),
                            title: Text('${addressall.addresses[index]['bname']} - ${addressall.addresses[index]['bcode']} - ${addressall.addresses[index]['prefix']}'),
                            subtitle: Text(
                                '${addressall.addresses[index]['address']}'),
                          ),
                          
                        ],
                      ),
                    ),
                  );
                })
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Add New'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: bcode,
                            decoration: InputDecoration(
                              labelText: 'Branch Code',
                            ),
                          ),
                          TextFormField(
                            controller: bname,
                            decoration: InputDecoration(
                              labelText: 'Branch Name',
                            ),
                          ),
                          TextFormField(
                            controller: address,
                            decoration: InputDecoration(
                              labelText: 'Address',
                            ),
                          ),
                          TextFormField(
                            controller: prefix,
                            decoration: InputDecoration(
                              labelText: 'Prefix',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    RaisedButton(
                        child: Text("Add"),
                        onPressed: () {
                          var prevadd;
                          if(addressall==null){
                            prevadd = [];
                          }else{
                            prevadd=addressall.addresses;
                          }
                          prevadd.add({
                            "bname":bname.text.toString(),
                            "bcode":bcode.text.toString(),
                            "address":address.text.toString(),
                            "prefix":prefix.text.toString()
                          });
                          box.put('address',Address(id: "20101104046", addresses: prevadd));
                          setState(() {
                            
                          });
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        },
        tooltip: 'Add New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
