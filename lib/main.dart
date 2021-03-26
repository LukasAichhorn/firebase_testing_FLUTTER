//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {


    return MultiProvider(
        providers: [
          StreamProvider<User>(create: (context) => FirebaseAuth.instance.authStateChanges()),

    ],

      child: MaterialApp(
      title: 'Will Answer for Gold',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/":(context) => MyHomePage(),
        "/register":(context)  => RegisterPage(),
        "/SingleShout":(context)  => SingleShoutPage(),


      },
    ),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    //final bool isAuthenticated = Provider.of<GlobalState>(context).isAuthenticated;
    final user = Provider.of<User>(context);
    final bool  isAuthenticated = user != null;

    return Scaffold(
      drawer:Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
        DrawerHeader(

          child: Image(image: AssetImage("assets/marginalia-navigation-support.png"),),
          decoration: BoxDecoration(
          color: Colors.amber,
        ),
      ),
              ListTile(
                title: Text("My Profile"),
                onTap: (){},
              ),
              ListTile(
                title: Text("my Shouts"),
                onTap: (){},
              ),
              ListTile(
                title: Text("my echos"),
                onTap: (){},
              ),
          ],
      ),
    ),
     appBar: AppBar(
       actions:<Widget> [
         IconButton(
             icon: const Icon(Icons.logout),
             onPressed: ()async{
               try{
                  _auth.signOut();
                  Navigator.pushNamed(context, "/");
               }
               catch(e){
                 print("$e");
               }

             })
       ],
      title: Text("MyHomePage Class"),

    ),
    body: isAuthenticated ? FrontPage() : LoginPage(),

    );
  }
}
class FrontPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          body: Container(
            child: ShowShouts(),

          ),
          floatingActionButton:
            new FloatingActionButton(
                onPressed:()=>{
                  showDialog(
                      context: context,
                    builder: (context){
                        return StatefulBuilder(builder: (context,setState){

                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: Column(

                              children:<Widget> [
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 6.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.0, 2.0), // shadow direction: bottom right
                                        )
                                      ],
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(20),bottomRight:  Radius.circular(20)),
                                    //border: Border.all(width: 4, color: Colors.amber,style: BorderStyle.solid),
                                  ),
                                  child:
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Create a new Shout"),
                                      ],
                                    )
                                  ),
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Column(
                                    children:<Widget> [
                                      //insert stateful class
                                      CreateShout(),
                                      Text("help me i am lost"),

                                    ],
                                  ),
                                ),

                              ],
                            )

                );
                });
                }

                ),
                },
              child: Icon(Icons.add),
                ),


        );
  }

}



class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32.0),
            child: LoginForm(),
          ),
        ],
      );
  }


}
class RegisterForm extends StatefulWidget{
  @override
  RegisterFormState createState(){
    return RegisterFormState();
  }
}
class RegisterFormState extends State<RegisterForm>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
        key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children:<Widget> [
          TextFormField(

            controller: _emailController,
            validator: (value){
              if(value.isEmpty){
                return "Please enter some text";
                }
              return null;
              },
            decoration: InputDecoration(
              labelText: "Enter your Email"
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: _pwController,
            validator: (value){
              if(value.isEmpty){
                return "Please enter some text";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Enter your pw"
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/");
                  },
                  child: Text("back")
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                ),


                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    try {
                      final User user = (await _auth.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _pwController.text
                      )).user;
                      // insert user data into database:
                      await FirebaseFirestore.instance.collection("users")

                      .add({
                        "userId": user.uid,
                        "email": _emailController.text,
                        "createdAt": FieldValue.serverTimestamp(),
                        "updatedAt": FieldValue.serverTimestamp()
                      });
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("successfully created user")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                      print(e);
                    }
                  }
                }, child: Text("register"),
              ),

            ],
          )

        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget{
  @override
  LoginFormState createState(){
    return LoginFormState();
  }
}
class LoginFormState extends State<LoginForm>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children:<Widget> [
          TextFormField(

            controller: _emailController,
            validator: (value){
              if(value.isEmpty){
                return "Please enter some text";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Enter your Email"
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: _pwController,
            validator: (value){
              if(value.isEmpty){
                return "Please enter some text";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Enter your pw"
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
            ),
            onPressed: () async {
              if(_formKey.currentState.validate()){
                try {
                  final User user = (await _auth.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _pwController.text
                  )).user;

                  Navigator.pushNamed(context, "/");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                  print(e);
                }


              }
            }, child: Text("login"),
          ),
          Text("Dont have an account?"),
          TextButton(
              onPressed: (){

                Navigator.pushNamed(context, "/register");
              },
              child: Text("create account"))

        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Register page Class"),

        ),
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(32.0),
                child: RegisterForm(),
            ),
          ],
        )

    );
  }
}

class CreateShout extends StatefulWidget{
  @override
  _CreateShoutState createState() => _CreateShoutState();
}

class _CreateShoutState extends State<CreateShout> {
  final _csFormKey = GlobalKey <FormState>();
  final _shoutContentController = TextEditingController();

  File _image;
  Future getImage(bool gallery) async{
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    if(gallery){
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    else{
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }
    setState(() {
      if(pickedFile != null){
        _image= File(pickedFile.path);
      }
      else{
        print("No Image was selected");
      }
    });
  }
  @override
  void dispose() {
    _shoutContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _csFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _shoutContentController,
            decoration: InputDecoration(
              labelText: "Enter your Question"
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter some text";
              }
              return null;
            },

          ),
          ElevatedButton(
              onPressed: () {
                getImage(false);
              },

              child:Icon(
                Icons.add_a_photo_rounded
              ),
          ),
         Container(
           width: 100.0,
           height: 100.0,
           decoration: BoxDecoration(
             border: Border.all(color: Colors.amber,width: 1.5),
           ),
           child:  _image != null ? Image.file(_image) : null,
         ),

          ElevatedButton(
              onPressed: () async {
                // save img to firebase store
                //get picture location
                // insert data into Database
                if(_csFormKey.currentState.validate()){
                  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                  print(_image.path);
                  String _basename = basename(_image.path);

                  try {
                    await firebase_storage.FirebaseStorage.instance
                        .ref(_basename)
                        .putFile(_image);
                    String downloadURL =  await firebase_storage.FirebaseStorage.instance.ref(_basename).getDownloadURL();
                    print(downloadURL);
                    print(_shoutContentController.text);
                    print(_auth.currentUser.uid);
                    CollectionReference shouts = FirebaseFirestore.instance.collection('shouts');
                    shouts.add({
                      "userId": _auth.currentUser.uid,
                      "shout_question": _shoutContentController.text,
                      "img_location": downloadURL,
                      "createdAt": FieldValue.serverTimestamp(),
                      "echo" : 10,

                    });

                      Navigator.pop(context);

                  } on FirebaseException catch (e) {
                    // e.g, e.code == 'canceled'
                  }

                  }
                },

              child: Text("Send Shout!"),
          ),
        ],
      ),
    );
  }
}


class ShowShouts extends StatefulWidget{

  @override
  _ShowShoutsState createState() => _ShowShoutsState();
}

class _ShowShoutsState extends State<ShowShouts> {
  Stream validShoutsList;

  @override
  void initState() {
    //we grad arguments from route, comming from drawer action
    // we provide info on which query to use
    // use switch case ?

    validShoutsList = FirebaseFirestore.instance.collection('shouts')
        //.where('valid',isEqualTo : true)
        .snapshots();


    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    //CollectionReference shouts = FirebaseFirestore.instance.collection("shouts");


    return StreamBuilder<QuerySnapshot>(
      stream: validShoutsList,
      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("Something went wrong while loading the Stream");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text("Loading...");
          }
          return new ListView(
            children: snapshot.data.docs.map( (DocumentSnapshot document){
             Timestamp createdDate = document.data()["createdAt"];
             DateTime currentTime = new DateTime.now();
             DateTime newCreatedDate , echoDate;
             Duration timeDiff;
             String sCreatedDate,minutes;
              if(createdDate != null){
                print("d--> i convert time stamp");
                 newCreatedDate = createdDate.toDate();
                 echoDate = newCreatedDate.add(new Duration(minutes: document.data()["echo"]));
                 sCreatedDate  = "${newCreatedDate.year.toString()}-${newCreatedDate.month.toString().padLeft(2,'0')}-${newCreatedDate.day.toString().padLeft(2,'0')} ${newCreatedDate.hour.toString()}:${newCreatedDate.minute.toString()}";
                 timeDiff = echoDate.difference(currentTime);
                  minutes = timeDiff.inMinutes.toString();
              }
              else{
                print("d--> i convert only to sting");
                sCreatedDate = "something went wrong with the date here";
              }


              return new Card(

                child: InkWell(
                  splashColor: Colors.orangeAccent.withAlpha(30),
                  onTap: (){

                    Navigator.pushNamed(context,
                      "/SingleShout",
                    arguments: <String,String>{
                      "shoutId": document.reference.id
                    }
                    );
                  },
                  child: Column(
                    children:<Widget> [
                      Container(
                        color: Colors.amber,
                        width: double.infinity,
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:<Widget> [
                            Text(sCreatedDate),
                            Text("echos: " + minutes + " min."),
                            Chip(
                              label: Text('100g'),
                              backgroundColor: Colors.white,
                            ),

                          ],
                        ),
                      ),
                      ListTile(
                        title: Text(
                          document.data()["shout_question"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: (document.data()["img_location"] != null) ? Icon(Icons.photo):null,

                      ),

                    ],
                  ),
                ),
              );
            }
            ).toList(),
          );
      }
    );
  }
}

class SingleShoutPage extends StatefulWidget{
  @override
  _SingleShoutPageState createState() => _SingleShoutPageState();
}

class _SingleShoutPageState extends State<SingleShoutPage> {

  @override
  Widget build(BuildContext context) {
    final Map shoutId = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
    final String documentId = shoutId["shoutId"];
    CollectionReference shouts = FirebaseFirestore.instance.collection(
        'shouts');

    return FutureBuilder<DocumentSnapshot>(
      future: shouts.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          List<dynamic> answers= data["answers"];
          Map<String,dynamic> answer = answers[0];
          print(answer);
          print(answer["answer_text"]);
          DateTime now = DateTime.now();
          DateTime createdAt = data["createdAt"].toDate();
          DateTime echosAt = createdAt.add(Duration(minutes: data["echo"]));
          String createdAtS  = "${createdAt.day.toString()}.${createdAt.month.toString().padLeft(2,'0')}.${createdAt.year.toString().padLeft(2,'0')} ${createdAt.hour.toString()}:${createdAt.minute.toString()}";
          Duration timeDiff = echosAt.difference(now);
          String minutes = timeDiff.inMinutes.toString();


          return Scaffold(
            appBar: AppBar(
              title: Text("show single post page"),
            ),
            body: Container(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.0),
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(

                        image: NetworkImage(data["img_location"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        height:MediaQuery.of(context).size.height * 0.45,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 20.0,
                              spreadRadius: 0.0,
                              offset: Offset(0.0, -1.0), // shadow direction: bottom right
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10.0),

                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(createdAtS),
                                Chip(
                                  label: Text( "echos: "+ minutes + " min"),
                                  backgroundColor: Colors.red,
                                ),
                                Chip(
                                  label: Text( "reward:" + data["reward"].toString() + 'g'),
                                  backgroundColor: Colors.red,
                                ),
                              ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data["shout_question"],
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: answers.length,
                                  itemBuilder: (BuildContext context, int i){
                                    Map<String,dynamic> answer = answers[i];
                                    return new Card(
                                       child: Column(
                                         children: [
                                           ListTile(
                                             title: Text(answer["answer_text"]),
                                             subtitle: Text("written by:" + answer["userId"]),
                                           ),


                                         ],

                                       ),
                                    );
                                  })
                            ],
                          )
                        ),
                      )
                    ],
                  ),


                ],
              ),
            )
          );
        }

        return Text("loading");
      },
    );
  }
}





