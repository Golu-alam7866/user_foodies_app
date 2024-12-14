import 'package:get/get.dart';

SnackbarController snackBar({required String title,required String message}){
  return Get.snackbar(title, message);
}