import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {

  UserProfileModel({
    super.documentId, 
    super.fullName, 
    super.phone, 
    super.address, 
    super.city, 
    super.country, 
    super.postalCode, 
    super.dob, 
    super.gender, 
    super.profileImage
  });

  factory UserProfileModel.fromJson( Map<String, dynamic> json){
    return UserProfileModel(
      address: json['address'],
      city: json['city'],
      country: json['country'],
      dob: json['dob'] != null 
          ? DateTime.parse( json['dob'] )
          : null,
      documentId: json['documentId'],
      fullName: json['fullName'],
      gender: json['gender'],
      phone: json['phone'],
      postalCode: json['postalCode'],
      profileImage: json['profileImage'] != null
        ? ApiConstants.baseUrl + (json['profileImage']['url'] as String)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fullName   != null) 'fullName':   fullName,
      if (phone      != null) 'phone':      phone,
      if (address    != null) 'address':    address,
      if (city       != null) 'city':       city,
      if (country    != null) 'country':    country,
      if (postalCode != null) 'postalCode': postalCode,
      'dob':        dob?.toIso8601String(), 
      'gender':     gender,

      'profileImage': profileImage != null                // send as int id if it's a number string, null to clear
        ? int.tryParse(profileImage!) ?? profileImage
        : null,
    };
  }
}