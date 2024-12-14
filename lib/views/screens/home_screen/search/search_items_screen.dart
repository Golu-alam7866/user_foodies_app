import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/search_controller.dart';

class SearchItemsScreen extends StatelessWidget {
  const SearchItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchItemsController searchItemsController = Get.put(SearchItemsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Search Here")),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[200]!, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: TextFormField(
                controller: searchItemsController.searchItemController.value,
                onChanged: (value) {
                  searchItemsController.searchKey.value = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search here ...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              return StreamBuilder<List<Map<String,dynamic>>>(
                stream: searchItemsController.searchInStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("An error occurred"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }

                  final products = snapshot.data!;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: (){},
                        child: ListTile(
                          title: Text(product['productName']),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}


