import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/user_auth/user_auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserAuthController userAuthController = Get.put(UserAuthController());
    return Scaffold(
      appBar: AppBar(title:const Text("Forgot Password"),centerTitle: true,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: userAuthController.usingEmailForForgotPasswordController.value,
                onChanged: (onChangeValue) {},
                validator: (validateValue) {},
                autocorrect: true,
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
                smartDashesType: SmartDashesType.enabled,
                smartQuotesType: SmartQuotesType.enabled,
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

              const SizedBox(height: 30,),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    userAuthController.forgotPassword();
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
                        : const Text("Forgot Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
