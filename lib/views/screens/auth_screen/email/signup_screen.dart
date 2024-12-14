import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/user_auth/user_auth_controller.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserAuthController userAuthController = Get.put(UserAuthController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8),
        child: Center(
          child: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Center(child: Text("SignUp Here", style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),),),
                  ],
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: TextFormField(
                          controller: userAuthController.userFirstNameController.value,
                          onChanged: (onChangeValue) {},
                          validator: (validateValue) {},
                          autocorrect: true,
                          keyboardType: TextInputType.name,
                          keyboardAppearance: Brightness.dark,
                          smartDashesType: SmartDashesType.enabled,
                          smartQuotesType: SmartQuotesType.enabled,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "First Name",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.blue)
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red)
                              )
                          ),
                        )
                    ),
                    const SizedBox(width: 20,),
                    Flexible(
                        child: TextFormField(
                          controller: userAuthController.userLastNameController.value,
                          onChanged: (onChangeValue) {},
                          validator: (validateValue) {},
                          autocorrect: true,
                          keyboardType: TextInputType.name,
                          keyboardAppearance: Brightness.dark,
                          smartDashesType: SmartDashesType.enabled,
                          smartQuotesType: SmartQuotesType.enabled,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Last Name",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.blue)
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red)
                              )
                          ),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: userAuthController.userEmailController.value,
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
                  controller: userAuthController.userPasswordController.value,
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
                TextFormField(
                  controller: userAuthController.userContactController.value,
                  onChanged: (onChangeValue) {},
                  validator: (validateValue) {},
                  autocorrect: true,
                  keyboardType: TextInputType.phone,
                  keyboardAppearance: Brightness.dark,
                  smartDashesType: SmartDashesType.enabled,
                  smartQuotesType: SmartQuotesType.enabled,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Contact",
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
                      userAuthController.createUserWithEmailAndPassword();
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
                          : const Text("SignUp", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
                    ),
                  );
                }),
                const SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                    Get.offAll(const SignInScreen());
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
                      child: Text("SignIn", style: TextStyle(color: Colors
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
