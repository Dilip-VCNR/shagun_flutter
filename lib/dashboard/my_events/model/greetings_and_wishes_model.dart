// To parse this JSON data, do
//
//     final greetingsAndWishesModel = greetingsAndWishesModelFromJson(jsonString);

import 'dart:convert';

GreetingsAndWishesModel greetingsAndWishesModelFromJson(String str) => GreetingsAndWishesModel.fromJson(json.decode(str));

String greetingsAndWishesModelToJson(GreetingsAndWishesModel data) => json.encode(data.toJson());

class GreetingsAndWishesModel {
  bool? status;
  List<ActiveGreetingCard>? activeGreetingCards;
  List<String>? wishes;

  GreetingsAndWishesModel({
    this.status,
    this.activeGreetingCards,
    this.wishes,
  });

  factory GreetingsAndWishesModel.fromJson(Map<String, dynamic> json) => GreetingsAndWishesModel(
    status: json["status"],
    activeGreetingCards: json["active_greeting_cards"] == null ? [] : List<ActiveGreetingCard>.from(json["active_greeting_cards"]!.map((x) => ActiveGreetingCard.fromJson(x))),
    wishes: json["wishes"] == null ? [] : List<String>.from(json["wishes"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "active_greeting_cards": activeGreetingCards == null ? [] : List<dynamic>.from(activeGreetingCards!.map((x) => x.toJson())),
    "wishes": wishes == null ? [] : List<dynamic>.from(wishes!.map((x) => x)),
  };
}

class ActiveGreetingCard {
  String? cardName;
  String? cardImageUrl;
  double? cardPrice;
  int? cardId;
  int? cardStatus;

  ActiveGreetingCard({
    this.cardName,
    this.cardImageUrl,
    this.cardPrice,
    this.cardId,
    this.cardStatus,
  });

  factory ActiveGreetingCard.fromJson(Map<String, dynamic> json) => ActiveGreetingCard(
    cardName: json["card_name"],
    cardImageUrl: json["card_image_url"],
    cardPrice: json["card_price"]?.toDouble(),
    cardId: json["card_id"],
    cardStatus: json["card_status"],
  );

  Map<String, dynamic> toJson() => {
    "card_name": cardName,
    "card_image_url": cardImageUrl,
    "card_price": cardPrice,
    "card_id": cardId,
    "card_status": cardStatus,
  };
}
