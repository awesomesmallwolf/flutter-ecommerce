class Address {
  final String firstName;
  final String lastName;
  final String state;
  final String address1;
  final String address2;
  final String city;
  final String mobile;
  final String pincode;
  final int stateId;
  final int id;

  Address(
      {this.id,
      this.firstName,
      this.address1,
      this.address2,
      this.city,
      this.lastName,
      this.mobile,
      this.pincode,
      this.state,
      this.stateId});
}
