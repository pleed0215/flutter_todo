class People {
  String name;
  double height;
  double weight;
  double? bmi;

  People({required this.name, required this.height, required this.weight}) {
    bmi = weight / ((height / 100) * (height / 100));
  }
}
