import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodies/views/screens/category/show_products_by_category_screen.dart';
import 'package:get/get.dart';

import '../../../controllers/category_controller.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController categoryController = Get.put(CategoryController());
    return Scaffold(
      appBar: AppBar(title: const Text("Category Screen"),),
      body: Obx(() {
        if(categoryController.categoryList.isEmpty){
          return const Center(child: Text("No category available"),);
        }
        return GridView.builder(
          itemCount: categoryController.categoryList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8
          ),
          itemBuilder: (context,index) {
            var data = categoryController.categoryList[index];
            return GestureDetector(
              onTap: (){
                categoryController.getProductByCategory(categoryId: data.id.toString());
                Get.to(()=> ShowProductsByCategoryScreen(categoryData : data));
              },
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: data.categoryImage.toString(),width: 50,height: 50,fit: BoxFit.cover,
                        placeholder: (context, url) => const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Flexible(
                      child: Text(
                        data.categoryName.toString(),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                  )
                ],
              ),
            );
        } );
      },)
    );
  }
}
