class Baby {
  String? name;
  DateTime? dob;
  String? collectionId;
  List<dynamic>? caregivers;

  Baby({this.name, this.dob, this.collectionId, this.caregivers});

  updateName(String name) {
    this.name = name;
  }

  updateDob(DateTime dob) {
    this.dob = dob;
  }

  updateCaregivers(Map<String, String> caregivers) {
    this.caregivers?.add(caregivers);
  }
}
