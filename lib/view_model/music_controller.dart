import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../parse/MusicModel.dart';

class MusicController extends GetxController {
  late Audio audioModel;
  List<MusicModel> audioList = [];

  RxInt length = 0.obs;
  RxString selectedAudioName = ''.obs;

  RxDouble progressValue = 0.0.obs;
  RxInt secondsRemaining = 0.obs;
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer player2 = AudioPlayer();
  bool isMusicSelected = false;
  MusicModel? selectedMusic;

  // These lists must match the current audio list length.
  // (Old code hardcoded 15, which breaks when DB has >15 songs.)
  List<RxBool> itemPressed = <RxBool>[];
  List<RxBool> isPlaying = <RxBool>[];

  void ensureListCapacity(int count) {
    if (count <= 0) {
      itemPressed = <RxBool>[];
      isPlaying = <RxBool>[];
      update();
      return;
    }

    if (itemPressed.length != count) {
      itemPressed = List.generate(count, (index) => false.obs);
    }
    if (isPlaying.length != count) {
      isPlaying = List.generate(count, (index) => false.obs);
    }
    update();
  }

  void toggleItemPressed(int index) {
    if (index < 0 || index >= itemPressed.length) return;
    for (int i = 0; i < itemPressed.length; i++) {
      if (i == index) {
        itemPressed[index].value = !itemPressed[index].value;
      } else {
        itemPressed[i].value = false;
      }
    }
  }

  void togglePlayItemPressed(int index) {
    if (index < 0 || index >= isPlaying.length) return;
    for (int i = 0; i < isPlaying.length; i++) {
      if (i == index) {
        isPlaying[index].value = !isPlaying[index].value;
      } else {
        isPlaying[i].value = false;
      }
      update();
    }
  }

  Future<void> loadAudio(String url) async {
    await player.setUrl(url); //load a url in audio player
  }

  Future<void> loadAudio2(String url) async {
    await player2.setUrl(url); // load a url in preview player
  }

  Future<void> playMusic() async {
    await player.setLoopMode(LoopMode.all);
    await player.play();
  }

  Future<void> stopMusic() async {
    await player.stop();
  }

  @override
  void onInit() {
    init();

    super.onInit();
  }

  Future<void> init() async {
    audioList = await getAudioData();
    ensureListCapacity(audioList.length);
  }

  static Future<List<MusicModel>> getAudioData() async {
    List<MusicModel> audios = [];

    QueryBuilder<MusicModel> queryBuilder =
        QueryBuilder<MusicModel>(MusicModel());
    queryBuilder.orderByDescending(MusicModel.keyCreatedAt);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      if (apiResponse.results != null) {
        // Iterate through the fetched results
        for (MusicModel musicModel in apiResponse.results!) {
          audios.add(musicModel);
        }

        return audios;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<void> _playMusic() async {
    // await player.set(LoopMode.all);
    await player.play();
  }

  Future<void> _stopMusic() async {
    await player.stop();
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    player2.stop();
    player2.dispose();
    super.onClose();
  }
}
