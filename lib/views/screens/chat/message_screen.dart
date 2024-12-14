import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/image_constants.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            )),
        title: Row(
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    popularMenu1,
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ali",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Online",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
             Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red
                              ),
                              width: Get.width * 0.6,
                                child: const Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Hlo Alam",style: TextStyle(color: Colors.white,fontSize: 15),),
                                    )),
                                  ],
                                )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.green
                              ),
                              width: Get.width * 0.6,
                              height: Get.height * 0.05,
                              child: const Center(child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Hlo Ali",style: TextStyle(color: Colors.white,fontSize: 15),),
                                  )),
                                ],
                              )),
                            ),
                            SizedBox(
                              width: Get.width * 0.7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("08:00 PM",style: TextStyle(fontSize: 12),),
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.done_all,size: 20,))
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],

                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Type your message ...",
                          border: InputBorder.none,
                          filled: false),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send_sharp),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
