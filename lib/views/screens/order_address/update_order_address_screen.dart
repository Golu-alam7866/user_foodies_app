import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/order_address_controller.dart';
import '../../../models/order_address_model.dart';
import '../../utils/action_dialog/snackBar.dart';
import '../../utils/widgets/custom_text_form_fields.dart';
import '../../utils/widgets/static_button.dart';

class UpdateOrderAddressScreen extends StatefulWidget {
  final OrderAddressModel data;
  const UpdateOrderAddressScreen({super.key, required this.data});

  @override
  State<UpdateOrderAddressScreen> createState() => _UpdateOrderAddressScreenState();
}

class _UpdateOrderAddressScreenState extends State<UpdateOrderAddressScreen> {
  Rx<TextEditingController> updateFullNameController = TextEditingController().obs;
  Rx<TextEditingController> updatePhoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> updatePincodeController = TextEditingController().obs;
  Rx<TextEditingController> updateStateController = TextEditingController().obs;
  Rx<TextEditingController> updateCityController = TextEditingController().obs;
  Rx<TextEditingController> updateHouseNumberBuildingNameController = TextEditingController().obs;
  Rx<TextEditingController> updateRoadNameAreaColonyController = TextEditingController().obs;

  @override
  void initState() {
    super.initState();
    updateFullNameController.value.text = widget.data.fullName.toString();
    updatePhoneNumberController.value.text = widget.data.phoneNumber.toString();
    updatePincodeController.value.text = widget.data.pincode.toString();
    updateStateController.value.text = widget.data.state.toString();
    updateCityController.value.text = widget.data.city.toString();
    updateHouseNumberBuildingNameController.value.text = widget.data.houseNumberBuildingName.toString();
    updateRoadNameAreaColonyController.value.text = widget.data.roadNameAreaColony.toString();
  }

  @override
  Widget build(BuildContext context) {
    OrderAddressController orderAddressController = Get.put(OrderAddressController());

    return Scaffold(
      appBar: AppBar(title: const Text("Update Order Address")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CustomTextFormFields(controller: updateFullNameController.value, labelText: "Full Name"),
                const SizedBox(height: 20),
                CustomTextFormFields(controller: updatePhoneNumberController.value, labelText: "Phone Number"),
                const SizedBox(height: 20),
                CustomTextFormFields(controller: updatePincodeController.value, labelText: "Pincode"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() {
                        // Whenever the state changes, update the text field
                        updateStateController.value.text = orderAddressController.updateState.value;
                        return CustomTextFormFields(
                          // controller: updateStateController.value.text.isEmpty ? orderAddressController.selectedState.value : updateStateController.value,  // Use the updated controller
                          controller: updateStateController.value,
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
                                          orderAddressController.updateState.value = state;
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  state,
                                                  style: const TextStyle(
                                                      overflow: TextOverflow.ellipsis,
                                                      fontSize: 16
                                                  ),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                            orderAddressController.updateState.value == state
                                                ? const Icon(Icons.check, color: Colors.green)
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
                    const SizedBox(width: 20),
                    Expanded(child: CustomTextFormFields(controller: updateCityController.value, labelText: "City")),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormFields(controller: updateHouseNumberBuildingNameController.value, labelText: "House No., Building Name"),
                const SizedBox(height: 20),
                CustomTextFormFields(controller: updateRoadNameAreaColonyController.value, labelText: "Road Name, Area, Colony"),
                const SizedBox(height: 30),
                StaticButton(
                    onTap: () {
                      if(updateFullNameController.value.text.isEmpty ||
                          updatePhoneNumberController.value.text.isEmpty ||
                          orderAddressController.updateState.value.isEmpty ||
                          updateCityController.value.text.isEmpty ||
                          updatePincodeController.value.text.isEmpty ||
                          updateHouseNumberBuildingNameController.value.text.isEmpty ||
                          updateRoadNameAreaColonyController.value.text.isEmpty){
                        snackBar(title: "Error", message: "All fields are required");
                        return;
                      }else{
                        OrderAddressModel updateOrderAddressModel = OrderAddressModel(
                            userId: widget.data.userId,
                            id: widget.data.id,
                            fullName: updateFullNameController.value.text.trim(),
                            phoneNumber: updatePhoneNumberController.value.text.trim(),
                            addressStatus: widget.data.addressStatus,
                            state: orderAddressController.updateState.value, // This value will be updated when state is selected
                            city: updateCityController.value.text.trim(),
                            pincode: updatePincodeController.value.text.trim(),
                            houseNumberBuildingName: updateHouseNumberBuildingNameController.value.text.trim(),
                            roadNameAreaColony: updateRoadNameAreaColonyController.value.text.trim()
                        );
                        orderAddressController.updateOrderAddress(id: widget.data.id.toString(), updateOrderAddressModel: updateOrderAddressModel);
                      }
                    },
                    data: "Update Address"
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}