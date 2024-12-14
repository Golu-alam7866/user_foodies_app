import 'package:flutter/material.dart';
import 'package:foodies/views/screens/order_address/update_order_address_screen.dart';
import 'package:get/get.dart';
import '../../../controllers/order_address_controller.dart';
import 'add_order_address_screen.dart';

class ViewAllAddressesScreen extends StatelessWidget {
  const ViewAllAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderAddressController orderAddressController = Get.put(OrderAddressController());

    // Ensure that the first address with addressStatus = true is selected
    if (orderAddressController.userOrderAddressList.isNotEmpty) {
      // Find the index of the address with addressStatus == true
      var selectedAddressIndex = orderAddressController.userOrderAddressList.indexWhere((address) => address.addressStatus == true);
      if (selectedAddressIndex != -1) {
        orderAddressController.orderAddressStatus.value = selectedAddressIndex;  // Mark it as selected
      }
    }

    return Scaffold(
      appBar: AppBar(actions: [
        GestureDetector(
          onTap: () {
            Get.to(const AddOrderAddressScreen());
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                  color: Colors.blue),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),

      body: Obx(() {
        if (orderAddressController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderAddressController.userOrderAddressList.isEmpty) {
          return const Center(child: Text("Address Not Available"));
        }

        return ListView.builder(
          itemCount: orderAddressController.userOrderAddressList.length,
          itemBuilder: (context, index) {
            var addressData = orderAddressController.userOrderAddressList[index];

            // Check if the current address is selected (i.e., addressStatus == true)
            bool isSelected = addressData.addressStatus == true;

            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: PhysicalModel(
                elevation: 2,
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            addressData.fullName ?? "N/A", // Avoid null text
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          PopupMenuButton<int>( // Edit and Delete options
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 10),
                                    Text("Edit"),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 10),
                                    Text("Remove"),
                                  ],
                                ),
                              ),
                            ],
                            offset: const Offset(0, 50),
                            color: Colors.white,
                            elevation: 2,
                            onSelected: (value) {
                              if (value == 1) {
                                Get.to(UpdateOrderAddressScreen(data: addressData));
                              } else if (value == 2) {
                                orderAddressController.deleteOrderAddress(id: addressData.id.toString());
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${addressData.houseNumberBuildingName ?? "N/A"}, ${addressData.roadNameAreaColony ?? "N/A"}, ${addressData.city ?? "N/A"}, ${addressData.state ?? "N/A"} - ${addressData.pincode ?? "N/A"}",
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(addressData.phoneNumber ?? "N/A"),
                          Radio<int>(
                            value: index,
                            // groupValue: orderAddressController.orderAddressStatus.value,
                            groupValue: isSelected ? index : null,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              // Update the radio button selection only when the user selects a different address
                              if (orderAddressController.orderAddressStatus.value != value) {
                                orderAddressController.orderAddressStatus.value = value!;
                                orderAddressController.updateOrderAddressStatus(
                                  orderAddressId: addressData.id.toString(),
                                  index: index,
                                  status: true,
                                );
                              }
                            },
                            // Automatically check the first address with addressStatus == true
                            // groupValue: isSelected ? index : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
