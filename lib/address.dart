import 'package:hive/hive.dart';

part 'address.g.dart';

@HiveType(typeId: 1)
class Address {
  Address({required this.id,required this.addresses});
  @HiveField(0)
  String id;

  @HiveField(1)
  List<dynamic> addresses;
}