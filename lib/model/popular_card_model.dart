import '../parse/LiveStreamingModel.dart';

class PopularModel {
  final String name;
  final String image;
  final String flag;
  final String country;
  final String countryCode;
  final int achievementCount;
  final String avatar;
  final LiveStreamingModel liveModel;

  PopularModel(
      {required this.country,
      this.countryCode = '',
      required this.liveModel,
      required this.achievementCount,
      required this.avatar,
      required this.name,
      required this.image,
      required this.flag});
}
