import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_notes_project/view/signup_screen.dart';

import '../controller/db_controller.dart';
import '../utils/const_value.dart';
import '../utils/shared_preferences_helper.dart';
import 'notes_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = true;
  bool rememberMe = false;

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData(){
    SharedPreferencesHelper().getPrefBool(
        key: ConstValue.rememberMe,
        defaultValue: false
    );
    if(rememberMe){
      emailController.text=SharedPreferencesHelper().getPrefString(
          key: ConstValue.email,
          defaultValue: ""
      );
      passwordController.text=SharedPreferencesHelper().getPrefString(
          key: ConstValue.password,
          defaultValue: ""
      );
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Center(
                  child: Image.asset("assets/images/NoteIcon.jpg",height: 200,width: 200,),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      label: Text("Email"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: passwordController,
                  obscureText: showPassword,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(onPressed: (){
                        showPassword=!showPassword;
                        setState(() {});
                      }, icon: Icon(showPassword?Icons.visibility:Icons.visibility_off),),
                      label: Text("Password"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Checkbox(value: rememberMe,
                      onChanged: (value){rememberMe=value!;setState(() {});},
                    ),
                    Text("Remember Me"),
                  ],
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: () async{
                  DbController dbController = DbController();
                  bool response= await dbController.login(
                      email: emailController.text,
                      password: passwordController.text);
                  if(response){
                    if(rememberMe) {
                      SharedPreferencesHelper().savePrefString(
                          key: ConstValue.email, value: emailController.text);
                      SharedPreferencesHelper().savePrefString(
                          key: ConstValue.password, value: passwordController.text);

                    }
                    else {
                      await SharedPreferencesHelper().remove(
                          key: ConstValue.email);
                      await SharedPreferencesHelper().remove(
                          key: ConstValue.password);
                    }
                    SharedPreferencesHelper().savePrefBool(
                        key: ConstValue.rememberMe, value: rememberMe);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NotesScreen()));
                    setState(() {});
                  }
                  else{
                    showDialog(context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("Invalid Email or Password"),
                            actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text("Ok"))
                          ],);
                        });
                  }
                }
                    ,child: Text("LogIn")),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                }, child: Text("SignUp")),
              ],
            ),
          )
      ),
    );
  }
}
