import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/constants/styles.dart';
import '../../utils/constants/text_constants.dart';
import 'message_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(chatText, style: AppTextStyle().userTextBold()),
        actions: [
         TextButton(onPressed: (){}, child: const Text("All Restaurants / Hotels"))
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Get.to(()=> const MessageScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PhysicalModel(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                elevation: 0.5,
                child: SizedBox(
                  height: Get.height / 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              popularMenu1,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ali",
                                style: AppTextStyle().textSize16TextBold(),
                              ),
                              const SizedBox(
                                width: 150,
                                  child: Text("Hi Ali This is your last message")),
                            ],
                          ),
                        ],
                      ),
                      Text("00:00",style: AppTextStyle().textSize16TextBold())
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
