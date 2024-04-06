class Baby {
  String name;
  DateTime dob;
  String collectionId;
  String primaryCaregiverUid;
  List<dynamic> caregivers; 
  //This is a map that looks like:
  // {
  //  doc: String
  //  name: String
  //  uid: String
  //  canPost: bool
  //  caregiver: bool // false if a social only, true if access to tracking info
  // }
  List<dynamic>? socialUsers;

  Baby(
      {required this.name,
      required this.dob,
      required this.collectionId,
      required this.primaryCaregiverUid,
      required this.caregivers,
      this.socialUsers});

  updateName(String name) {
    this.name = name;
  }

  updateDob(DateTime dob) {
    this.dob = dob;
  }

  updateCaregivers(Map<String, String> caregivers) {
    this.caregivers.add(caregivers);
  }
}
