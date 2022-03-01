import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/signup_screen.dart';
import '/utils/lottie_animation.dart';
import '/widgets/general_alert_dialog.dart';
import '/utils/choose_account_button.dart';
import '/utils/submit_button.dart';
import '/utils/text_form_field.dart';
import '/constants/constant.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Padding(
          padding: basePadding,
          child: SingleChildScrollView(
            child: Padding(
              padding: basePadding,
              child: Column(
                children: [
                  LottieAnimation("Welcome Back"),
              
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InputTextField(
                          title: "Email",
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          validate: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter your username";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          title: "Password",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          controller: passwordController,
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            color: Colors.black,
                          ),
                          validate: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GeneralSubmitButton(
                          onPressed: () async {
                            
                            if (formKey.currentState!.validate()) {
                              GeneralAlertDialog().customLoadingDialog(context);
                              final email = emailController.text;
                              final password = passwordController.text;
                             

                             
                              try{
                                final user = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(),
                                  ),
                                );
                              }
                              on FirebaseAuthException catch(e){
                              String message = "";
                              if(e.code == "user-not-found"){
                                message = "The user does not exist";
                              }
                              else if(e.code == "invalid-email"){
                                message = "The email address is invalid";
                              }
                              else if(e.code == "wrong-password"){
                                message = "Incorrect password";
                              }
                              else if(e.code == "too-many-requests"){
                                message = "Your account is locked. Please try again later";
                              }
                              
                              Navigator.of(context).pop();
                              GeneralAlertDialog().customAlertDialog(context,message);
                              
                            }
                            catch(ex){
                               Navigator.of(context).pop();
                              GeneralAlertDialog().customAlertDialog(context, ex.toString());

                            }

                             
                            }
                           
                            
                          },
                          
                          bottonTitle: "Login",
                        ),
                      ],
                    ),
                  ),
                  GeneralChooseAccountPage(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SignUpScreen(),
                        ),
                      );
                    },
                    text: "Don't have an account?",
                    accountTitle: "Register",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
