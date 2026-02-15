class User {
  int customerId;
  String firstName;
  String lastName;
  String username;
  String email;
  String phone;
  String profilePhotoUrl;

  User({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      customerId: json['c_id'] as int,
      firstName: json['c_firstname'] as String,
      lastName: json['c_lastname'] as String,
      username: json['c_username'] as String,
      email: json['c_email'] as String,
      phone: json['c_phone'] as String,
      profilePhotoUrl: "https://xotic.in/api/${json['c_photo']}",
    );
  }

  void setCustomerId(int customerId) {
    this.customerId = customerId;
  }

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  void setUsername(String username) {
    this.username = username;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }

  void setProfilePhotoUrl(String url) {
    this.profilePhotoUrl = url;
  }
}
