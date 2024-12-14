import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/user_auth/user_auth_controller.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserAuthController userAuthController = Get.put(UserAuthController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Center(child: Text("SignIn Here", style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),),),
                  ],
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  controller: userAuthController.userSignEmailController.value,
                  onChanged: (onChangeValue) {},
                  validator: (validateValue) {},
                  autocorrect: true,
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.dark,
                  smartDashesType: SmartDashesType.enabled,
                  smartQuotesType: SmartQuotesType.enabled,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Email",
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red)
                      )
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: userAuthController.userSignPasswordController.value,
                  onChanged: (onChangeValue) {},
                  validator: (validateValue) {},
                  autocorrect: true,
                  keyboardType: TextInputType.visiblePassword,
                  keyboardAppearance: Brightness.dark,
                  smartDashesType: SmartDashesType.enabled,
                  smartQuotesType: SmartQuotesType.enabled,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Password",
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red)
                      )
                  ),
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    Get.to(const ForgotPasswordScreen());
                  },
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Text("Forgot password?",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                  ),
                ),
                const SizedBox(height: 30,),
                Obx(() {
                  return GestureDetector(
                    onTap: () async{
                      await userAuthController.signInUserWithEmailAndPassword();
                    },
                    child: Container(
                      width: Get.width * 0.7,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue
                      ),
                      child: Center(child: userAuthController.isLoading.value
                          ? const CupertinoActivityIndicator(color: Colors.white,)
                          : const Text("SignIn", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
                    ),
                  );
                }),
                const SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                    Get.offAll(const SignUpScreen());
                  },
                  child: Container(
                    width: Get.width * 0.7,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey)
                    ),
                    child: const Center(
                      child: Text("SignUp", style: TextStyle(color: Colors
                          .black, fontWeight: FontWeight.bold),),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

