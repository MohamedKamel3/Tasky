class OnBoardingModel {
  final String image;
  final String title;
  final String description;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnBoardingModel> onBoardingList() => [
  OnBoardingModel(
    image: "assets/images/on_boarding1.png",
    title: "Manage your tasks",
    description:
        "You can easily manage all of your daily tasks in DoMe for free",
  ),
  OnBoardingModel(
    image: "assets/images/on_boarding2.png",
    title: "Create daily routine",
    description:
        "In Tasky  you can create your personalized routine to stay productive",
  ),
  OnBoardingModel(
    image: "assets/images/on_boarding3.png",
    title: "Orgonaize your tasks",
    description:
        "You can organize your daily tasks by adding your tasks into separate categories",
  ),
];
