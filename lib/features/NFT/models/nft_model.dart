import 'package:poster_stock/features/NFT/models/wallet_state.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class NFTModel {
  int idNft;
  String relatedPosterId;
  String imagePath;
  int allCount;
  int item;
  double priceInTON;
  double priceInUSD;
  WalletState wallet;
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
    required this.fee,
    required this.isSell,
    required this.owner,
    required this.wallet,
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
      fee: json['fee'],
      isSell: json['isSell'],
      owner: json['owner'],
      wallet: json['wallet'],
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
      'fee': fee,
      'isSell': isSell,
      'owner': owner,
      'wallet': wallet.toJson(),
    };
  }

  factory NFTModel.init() {
    return NFTModel(
      idNft: 0,
      relatedPosterId: '',
      imagePath: '',
      allCount: 0,
      item: 0,
      priceInTON: 0,
      priceInUSD: 0,
      fee: 0,
      isSell: false,
      owner: UserModel.init(),
      wallet: WalletState.init(),
    );
  }
}
