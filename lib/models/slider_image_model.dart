import 'dart:convert';

SliderImageModel sliderImageModelFromJson(String str) => SliderImageModel.fromJson(json.decode(str));

String sliderImageModelToJson(SliderImageModel data) => json.encode(data.toJson());

class SliderImageModel {
  String? sliderImageId;
  String? sliderImageName;
  String? sliderImageCreatedAt;
  String? sliderImageUpdatedAt;

  SliderImageModel({
    this.sliderImageId,
    this.sliderImageName,
    this.sliderImageCreatedAt,
    this.sliderImageUpdatedAt,
  });

  factory SliderImageModel.fromJson(Map<String, dynamic> json) => SliderImageModel(
    sliderImageId: json["sliderImageId"],
    sliderImageName: json["sliderImageName"],
    sliderImageCreatedAt: json["sliderImageCreatedAt"],
    sliderImageUpdatedAt: json["sliderImageUpdatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "sliderImageId": sliderImageId,
    "sliderImageName": sliderImageName,
    "sliderImageCreatedAt": sliderImageCreatedAt,
    "sliderImageUpdatedAt": sliderImageUpdatedAt,
  };
}
