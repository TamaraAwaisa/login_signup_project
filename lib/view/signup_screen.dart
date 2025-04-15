import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/db_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  bool showPassword=true;
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
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_rounded),
                    label: Text("UserName"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                ),
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
              ElevatedButton(onPressed: ()async{
                DbController dbController=DbController();
                await dbController.signUp(name: nameController.text, email: emailController.text, password: passwordController.text);
                Navigator.pop(context);
              }, child: Text("SignUp")),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("LogIn")),
            ],
          ),
        ),
      ),
    );
  }
}