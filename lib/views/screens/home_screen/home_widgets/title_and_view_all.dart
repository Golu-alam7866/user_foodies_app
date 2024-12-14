import 'package:flutter/material.dart';

import '../../../utils/constants/styles.dart';

class TitleAndViewAllText extends StatelessWidget {
   const TitleAndViewAllText({super.key,required this.data,required this.viewMore});
  
  final String data;
  final String viewMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(data,style: AppTextStyle().textSize16TextBold(),),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue[50],
            border: Border.all(color: Colors.blue)
          ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
              child: Text(viewMore,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
            ),
        )
      ],
    );
  }
}
