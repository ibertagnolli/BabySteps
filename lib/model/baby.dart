class Baby {
  String name;
  DateTime dob;
  String collectionId;
  String primaryCaregiverUid;
  List<dynamic> caregivers;
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
