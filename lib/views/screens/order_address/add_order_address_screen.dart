import 'package:flutter/material.dart';
import 'package:foodies/views/screens/order_address/view_all_addresses_screen.dart';
import 'package:get/get.dart';
import '../../../controllers/order_address_controller.dart';
import '../../utils/widgets/custom_text_form_fields.dart';
import '../../utils/widgets/static_button.dart';

class AddOrderAddressScreen extends StatelessWidget {
  const AddOrderAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderAddressController orderAddressController = Get.put(OrderAddressController());
    return Scaffold(
      appBar: AppBar(actions: [
          GestureDetector(
            onTap: () {
              Get.to(const ViewAllAddressesScreen());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                  color: Colors.blue
                ),
                child: const Center(child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 1),
                  child: Text("View All Addresses",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),),
              ),
            ),
          )
      ],),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                CustomTextFormFields(controller: orderAddressController.fullNameController.value, labelText: "Full Name"),
                const SizedBox(height: 20,),
                CustomTextFormFields(controller: orderAddressController.phoneNumberController.value, labelText: "Phone Number"),
                const SizedBox(height: 20,),
                CustomTextFormFields(controller: orderAddressController.pincodeController.value, labelText: "Pincode"),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() {
                        return CustomTextFormFields(
                          controller: TextEditingController(text: orderAddressController.selectedState.value),
                          labelText: "State",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Select State"),
                                content: SizedBox(
                                  width: Get.width,
                                  child: ListView.builder(
                                    itemCount: orderAddressController.statesNameList.length,
                                    itemBuilder: (context, index) {
                                      String state = orderAddressController.statesNameList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          orderAddressController.selectedState.value = state;
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(state,style: const TextStyle(overflow: TextOverflow.ellipsis,fontSize: 16),maxLines: 2,),
                                              ),
                                            ),
                                            orderAddressController.selectedState.value == state
                                                ? const Icon(Icons.check,color: Colors.green,)
                                                : Container()
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(child: CustomTextFormFields(controller: orderAddressController.cityController.value, labelText: "City"),)
                  ],
                ),
                const SizedBox(height: 20,),
                CustomTextFormFields(controller: orderAddressController.houseNumberBuildingNameController.value, labelText: "House No., Building Name"),
                const SizedBox(height: 20,),
                CustomTextFormFields(controller: orderAddressController.roadNameAreaColonyController.value, labelText: "Road Name, Area, Colony"),
                const SizedBox(height: 30,),
                StaticButton(onTap: () {orderAddressController.addOrderAddress();}, data: "Save Address")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
