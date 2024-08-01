import 'package:poster_stock/features/home/models/nft_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class NFTModel {
  int idNft;
  String relatedPosterId;
  String imagePath;
  int allCount;
  int item;
  double priceInTON;
  double priceInUSD;
  BlockchainNetwork network;
  double fee;
  bool isSell;
  UserModel owner;

  NFTModel({
    required this.idNft,
    required this.relatedPosterId,
    required this.imagePath,
    required this.allCount,
    required this.item,
    required this.priceInTON,
    required this.priceInUSD,
    required this.network,
    required this.fee,
    required this.isSell,
    required this.owner,
  });

  factory NFTModel.fromJson(Map<String, dynamic> json) {
    return NFTModel(
      idNft: json['idNft'],
      relatedPosterId: json['relatedPosterId'],
      imagePath: json['imagePath'],
      allCount: json['allCount'],
      item: json['item'],
      priceInTON: json['priceInTON'],
      priceInUSD: json['priceInUSD'],
      network: json['network'],
      fee: json['fee'],
      isSell: json['isSell'],
      owner: json['owner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNft': idNft,
      'relatedPosterId': relatedPosterId,
      'imagePath': imagePath,
      'allCount': allCount,
      'item': item,
      'priceInTON': priceInTON,
      'priceInUSD': priceInUSD,
      'network': network,
      'fee': fee,
      'isSell': isSell,
      'owner': owner,
    };
  }
}
