class UserProfileEntity {
  final String?  documentId;
  final String?  fullName;
  final String?  phone;
  final String?  address;
  final String?  city;
  final String?  country;
  final String?  postalCode;
  final DateTime? dob;
  final String?  gender;
  final String?  profileImage;    // will store the full URL after parsing
  
  UserProfileEntity({
    this.documentId, 
    this.fullName, 
    this.phone, 
    this.address, 
    this.city, 
    this.country, 
    this.postalCode, 
    this.dob, 
    this.gender, 
    this.profileImage
  });
}