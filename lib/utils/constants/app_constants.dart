import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors_constant.dart';

class AppInfo {
  static const String packageName = "";
  static String appTitle = 'Touch Voice';
  static const String appStoreUrl =
      'https://apps.apple.com/us/app/itunes-connect/------id---------';
  static String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$packageName';
}

class AppImagePath {
  static const onBoardingImage = "assets/png/onboarding.png";
  static const googleIcon = "assets/png/ic_google.png";
  static const appleIcon = "assets/png/ic_apple.png";
  static const avatar = "assets/png/avatar.png";
  // Default avatars (used when user didn't upload a photo)
  static const defaultMaleAvatar = "assets/png/avatarmale.png";
  static const defaultFemaleAvatar = "assets/png/avatarfemale.png";
  static const personalIcon = "assets/png/ic_personal.png";
  static const genderIcon = "assets/png/ic_gender.png";
  static const languageIcon = "assets/png/ic_language.png";
  static const trendingIcon = "assets/png/ic_trending.png";
  static const linkIcon = "assets/png/ic_link.png";

  static const maleIcon = "assets/png/ic_male.png";
  static const femaleIcon = "assets/png/ic_female.png";
  static const phoneIcon = "assets/png/ic_phone.png";
  static const calendarIcon = "assets/png/ic_calendar.png";
  static const nameIcon = "assets/png/ic_name.png";
  static const progressIndicator = "assets/png/progress_indicator.png";

  static const tickIcon = "assets/png/ic_tick.png";
  static const pkBattleIcon = "assets/png/ic_battle.png";
  static const multiIcon = "assets/png/ic_multi.png";
  static const audioIcon = "assets/png/ic_audio.png";
  static const trendingHomeImage = "assets/png/trending_home_image.png";
  static const audioHomeImage = "assets/png/audio_home_image.png";
  static const pkHomeImage = "assets/png/pk_home_image.png";
  static const exploreHomeImage = "assets/png/explore_home_image.png";
  static const liveHomeImage = "assets/png/live_home_image.png";
  static const followersIcon = "assets/png/ic_followers.png";

  static const bangladeshFlag = "assets/svg/bangladesh_flag.svg";
  static const englandFlag = "assets/svg/Europe_Region_Flags/UK.svg";
  static const franceFlag = "assets/svg/france_flag.svg";
  static const saudiFlag = "assets/svg/saudia_flag.svg";
  static const swedishFlag = "assets/svg/swedish_flag.svg";
  static const ukraineFlag = "assets/svg/ukrine_flag.svg";
  static const pakistanFlag = "assets/svg/pakistan_flag.svg";
  static const americanFlag = "assets/svg/america_flags.svg";
  static const canadaFlag = "assets/svg/canada_flag.svg";
  static const cardImage2 = "assets/png/post-placeholder_1.png";
  static const logo = "assets/png/logo.png";
  static const diamond = "assets/svg/diamond.svg";
  static const searchIcon = "assets/svg/searchIcon.svg";
  static const trophyIcon = "assets/png/trophy.png";
  static const cameraIcon = "assets/png/camera.png";
  static const exploreIcon = "assets/png/bottomNav/ic_explore.png";
  static const homeIcon = "assets/png/bottomNav/ic_home.png";
  static const chatIcon = "assets/png/bottomNav/ic_chat.png";
  static const messageIcon = "assets/png/bottomNav/ic_message.png";
  static const profileIcon = "assets/png/bottomNav/ic_profile.png";
  static const liveIcon = "assets/png/bottomNav/ic_live.png";
  static const liveIconSvg = "assets/png/live.svg";

  /// Bottom navigation (HD SVG icons)
  /// Note: kept separate from the older PNG constants above because some of
  /// those are reused in other UI spots (not just the bottom nav).
  static const bottomNavHomeIcon = "assets/svg/Home-icon.svg";
  static const bottomNavExploreIcon = "assets/svg/Explore.svg";
  static const bottomNavChatIcon = "assets/svg/chat.svg";
  static const bottomNavProfileIcon = "assets/svg/profile.svg";
  static const bottomNavBackground = "assets/png/bottomNav/bottom_nav_bg.png";
  static const bottomNavTouchVoiceBg = "assets/png/touchvoice.jpg";

  /// Hilo APK v4.16.0 bottom-nav icons (selected / unselected webp pairs).
  static const hiloNavHomeSelected =
      "assets/png/bottomNav/hilo/icon_random_selected.webp";
  static const hiloNavHomeUnselected =
      "assets/png/bottomNav/hilo/icon_random_unselected.webp";
  static const hiloNavExploreSelected =
      "assets/png/bottomNav/hilo/icon_group_selected.webp";
  static const hiloNavExploreUnselected =
      "assets/png/bottomNav/hilo/icon_group_unselected.webp";
  static const hiloNavChatSelected =
      "assets/png/bottomNav/hilo/icon_chat_selected.webp";
  static const hiloNavChatUnselected =
      "assets/png/bottomNav/hilo/icon_chat_unselected.webp";
  static const hiloNavProfileSelected =
      "assets/png/bottomNav/hilo/icon_game_selected.webp";
  static const hiloNavProfileUnselected =
      "assets/png/bottomNav/hilo/icon_game_unselected.webp";
  static const splashIcon = logo;
  static const nothingIsHere = "assets/png/worldwide.png";

  /// Single live screen png/dashboard
  static const gemStone = "assets/png/streamer/gem_stone.png";
  static const wishBadge = "assets/png/streamer/wish_badge.png";
  static const profileBorder = "assets/png/streamer/profile_border.png";
  static const profilePic = "assets/png/streamer/profile_pic.png";
  static const diamondIcon = "assets/png/streamer/diamond.png";
  static const shareIcon = "assets/png/streamer/share.png";
  static const topPerson1 = "assets/png/streamer/top_person_1.png";
  static const topPerson2 = "assets/png/streamer/top_person_2.png";
  static const topPerson3 = "assets/png/streamer/top_person_3.png";
  static const chat = "assets/png/streamer/chat.png";
  static const menu = "assets/png/streamer/menu.png";
  static const link = "assets/png/streamer/link.png";
  static const sword = "assets/png/streamer/sword.png";
  static const subscriber = "assets/png/streamer/subscriber.png";
  static const filterWord = "assets/png/streamer/filter_word.png";
  static const beauty = "assets/png/streamer/beauty.png";
  static const bgm = "assets/png/streamer/bgm.png";
  static const whisper = "assets/png/streamer/whisper.png";
  static const switchIcon = "assets/png/streamer/switch.png";
  static const dataIcon = "assets/png/streamer/data.png";
  static const recordIcon = "assets/png/streamer/record.png";
  static const mirrorIcon = "assets/png/streamer/mirror.png";
  static const cameraOff = "assets/png/streamer/camera_off.png";
  static const instagram = "assets/png/streamer/insta.png";
  static const facebook = "assets/png/streamer/facebook.png";
  static const whatsapp = "assets/png/streamer/whatsapp.png";
  static const makeup = "assets/png/streamer/makeup.png";
  static const announcement = "assets/png/streamer/announcement.png";
  static const admin = "assets/png/streamer/admin.png";
  static const settings = "assets/png/streamer/settings.png";
  static const world = "assets/png/worldwide.png";
  static const chessIcon = "assets/png/streamer/chess.png";
  static const vsTime = "assets/png/streamer/vs_time.png";
  static const authentication = "assets/png/streamer/authentication.png";

  /// Battle Assets
  static const worldWide = "assets/png/streamer/battle/worldwide.png";
  static const battle1x1 = "assets/png/streamer/battle/battle-1x1.png";
  static const battle1x2 = "assets/png/streamer/battle/battle-1x2.png";
  static const battle1x3 = "assets/png/streamer/battle/battle-1x3.png";
  static const battle4x4 = "assets/png/streamer/battle/battle-4x4.png";
  static const battleTeamMate = "assets/png/streamer/battle/battle-team.png";
  static const battleBg1 = "assets/png/streamer/battle/battle_bg_1.png";
  static const battleBg2 = "assets/png/streamer/battle/battle_bg_2.png";
  static const startButton = "assets/png/streamer/battle/start_button.png";
  static const badge = "assets/png/streamer/battle/badge.png";
  static const filterStar = "assets/png/streamer/battle/filter_star.png";
  static const micIcon = "assets/png/streamer/battle/mic.png";
  static const shopIcon = "assets/png/streamer/battle/shop.png";
  static const vsIcon = "assets/png/streamer/battle/vs_icon.png";
  static const chestIcon = "assets/png/streamer/battle/chest.png";
  static const boxingIcon = "assets/png/streamer/battle/boxing.png";
  static const boxingDimIcon = "assets/png/boxing-dim.png";

  /// Audience Assets
  static const giftIcon = "assets/png/audience/gift.png";
  static const coinsIcon = "assets/png/audience/coins.png";
  static const statsIcon = "assets/png/audience/stats.png";
  static const marsIcon = "assets/png/audience/mars.png";
  static const subscribeBadge = "assets/png/audience/subscribe_badge.png";
  static const bubblesIcon = "assets/png/audience/bubbles.png";
  static const warningIcon = "assets/png/audience/warning.png";
  static const levelBadge = "assets/png/audience/level_badge.png";
  static const lightningIcon = "assets/png/audience/lightning.png";
  static const dislikeIcon = "assets/png/audience/dislike.png";
  static const whisperIcon = "assets/png/audience/whisper.png";
  static const megaphone = "assets/png/audience/megaphone.png";
  static const audienceBadge = "assets/png/audience/audience_badge.png";

  ///Streamer Assets
  static const sofaFilled = "assets/svg/sofa-filled.svg";

  /// Gifts Assets
  static const giftOverlay = "assets/png/audience/gifts/gift_overlay.png";
  static const lamborghiniImage = "assets/png/audience/gifts/lamborghini.png";
  static const bearCastleImage = "assets/png/audience/gifts/bear_castle.png";
  static const yachtIslandImage = "assets/png/audience/gifts/yacht_island.png";
  static const babyDragonImage = "assets/png/audience/gifts/baby_dragon.png";
  static const heartsImage = "assets/png/audience/gifts/hearts.png";
  static const kissingImage = "assets/png/audience/gifts/kissing_gift.png";
  static const motorCycleImage =
      "assets/png/audience/gifts/motorcycle_entry.png";

  /// Gifts Assets - SVGA assets

  static const babyDragon = "assets/svga/baby_dragon.svga";
  static const bearCastle = "assets/svga/bear_castle.svga";
  static const flyingPhoenix = "assets/svga/flying_phoenix.svga";
  static const hearts = "assets/svga/hearts.svga";
  static const kissingGift = "assets/svga/kissing_gift.svga";
  static const lamborghini = "assets/svga/lamborghini.svga";
  static const motorCycleEntry = "assets/svga/motorcycle_entry.svga";
  static const yachtIsland = "assets/svga/yacht_island.svga";

  /// Gifts Assets - Audio assets
  static const princessWeddingMp3 = "audios/princess_wedding_entry.mp3";
  static const happyBirthdayMp3 = "audios/happy_birthday.mp3";
  static const dragonMp3 = "audios/dragon.mp3";
  static const greatPalaceMp3 = "audios/great_palace.mp3";
  static const lionEntryMp3 = "audios/lion_entry.mp3";
  static const runningTigerMp3 = "audios/running_tiger.mp3";

  static const lamborghiniMp3 = "audios/lamborghini.mp3";
  static const bearCastleMp3 = "audios/bear_castle.mp3";
  static const yachtIslandMp3 = "audios/yacht_island.mp3";
  static const babyDragonMp3 = "audios/baby_dragon.mp3";
  static const flyingPhoenixMp3 = "audios/baby_dragon.mp3";
  static const heartMp3 = "audios/hearts.mp3";
  static const kissingGiftMp3 = "audios/kissing_gift.mp3";
  static const motorcycleMp3 = "audios/motorcycle_entry.mp3";

  /// battle animations
  static const loseEmojiJson = "assets/animations/battle/lose emoji.json";
  static const winEmojiJson = "assets/animations/battle/win emoji.json";
  static const drawEmojiJson = "assets/animations/battle/draw emoji.json";

  static const indexAnimation = "assets/svga/index.svga";

  // multiguest
  static const bitCoinSofa = "assets/png/streamer/bitcoin_sofa.png";
  static const multiGuestImage = "assets/png/streamer/multiGuestImage.png";
  static const multiGuestNumberIcon =
      "assets/png/streamer/multiGuestNumber.png";
  static const multiGuestNumberIcon2 =
      "assets/png/streamer/multiGuestNumberIcon2.png";
  static const deleteUser1 = "assets/png/streamer/deleteUser.png";
  static const guestCameraIcon = "assets/png/streamer/guestCameraIcon.png";
  static const guestGiftIcon = "assets/png/streamer/guestGiftIcon.png";
  static const youtube = "assets/png/streamer/youtube.png";
  static const boostIcon = "assets/png/streamer/boostIcon.png";
  // static const boost = "assets/png/streamer/boost.png";
  static const whippersIcons = "assets/png/streamer/whippersIcon.png";
  static const muteIcon = "assets/png/mute.png";
  static const youtubeImage = "assets/png/streamer/Disney+.png";
  static const multiGuestBlur = "assets/png/streamer/multiGuestBlur.png";
  static const onTop = "assets/png/streamer/onTop.png";
  static const multiGuestExpandIcon =
      "assets/png/streamer/multiGuestExpandIcon.png";
  static const screenShareIcon = "assets/png/streamer/screenShareIcon.png";
  static const screenShare = "assets/png/streamer/screen_share.png";
  static const sofa = "assets/png/streamer/sofa.png";

  // audio live
  static const gemStone1 = "assets/png/streamer/gemstone_badge.png";
  static const audioLiveBadge = "assets/png/streamer/audioLiveBadge.png";
  static const emptyRoomUser = "assets/png/streamer/empty_room_user.png";
  static const audioLiveCoin = "assets/png/streamer/audioLiveCoin.png";
  static const mic_off = "assets/png/streamer/mic_off.png";
  static const hand_wave = "assets/png/streamer/hand_wave.png";
  static const end_call = "assets/png/audience/end_call.png";

  // Game View png/dashboard

  static const mobileIcon = "assets/png/game/mobileIcon.png";
  static const pcIcon = "assets/png/game/pcIcon.png";
  static const verticalDisplay = "assets/png/game/verticalDisplay.png";
  static const horizontalDisplay = "assets/png/game/horizontalDisplay.png";
  static const sunIcon = "assets/png/userProfile/sunIcon.png";

  // popular screen png/dashboard

  static const popularBadge = "assets/png/home/popularBadge.png";
  static const trendPic = "assets/png/home/trend-pic.png";
  static const battleIcon = "assets/svg/battleIcon.svg";

  // America Region Flags
  static const USA = "assets/svg/America_Region_Flags/USA.svg";
  static const Argentina = "assets/svg/America_Region_Flags/Argentina.svg";
  static const Bolivia = "assets/svg/America_Region_Flags/Bolivia.svg";
  static const Brazil = "assets/svg/America_Region_Flags/Brazil.svg";
  static const Canada = "assets/svg/America_Region_Flags/Canada.svg";
  static const Chile = "assets/svg/America_Region_Flags/Chile.svg";
  static const Colombia = "assets/svg/America_Region_Flags/Colombia.svg";
  static const Costa_Rico = "assets/svg/America_Region_Flags/Costa_Rico.svg";
  static const Ecuador = "assets/svg/America_Region_Flags/Ecuador.svg";
  static const EL_Salvador = "assets/svg/America_Region_Flags/EL_Salvador.svg";
  static const Mexico = "assets/svg/America_Region_Flags/Mexico.svg";
  static const Nigeria = "assets/svg/America_Region_Flags/Nigeria.svg";
  static const Panama = "assets/svg/America_Region_Flags/Panama.svg";
  static const Peru = "assets/svg/America_Region_Flags/Peru.svg";
  static const Uruguay = "assets/svg/America_Region_Flags/Uruguay.svg";
  static const Venezuela = "assets/svg/America_Region_Flags/Venezuela.svg";

  // Asia region flags

  static const Pakistan = "assets/svg/Asia_Region_Flags/Pakistan.svg";
  static const China = "assets/svg/Asia_Region_Flags/China.svg";
  static const Bangladesh = "assets/svg/Asia_Region_Flags/Bangladesh.svg";
  static const India = "assets/svg/Asia_Region_Flags/India.svg";

  // Europe region flags
  static const France = "assets/svg/Europe_Region_Flags/France.svg";
  static const Germany = "assets/svg/Europe_Region_Flags/Germany.svg";
  static const Italy = "assets/svg/Europe_Region_Flags/Italy.svg";
  static const UK = "assets/svg/Europe_Region_Flags/UK.svg";

  // Middle east region flags

  static const Israel = "assets/svg/Middle_East_Region_Flags/Israel.svg";
  static const Qatar = "assets/svg/Middle_East_Region_Flags/Qatar.svg";
  static const Turkey = "assets/svg/Middle_East_Region_Flags/Turkey.svg";
  static const UAE = "assets/svg/Middle_East_Region_Flags/UAE.svg";

  // top streams png/dashboard
  static const red_redemption = "assets/png/top_streams/red_redemption.png";
  static const bravery = "assets/png/top_streams/bravery.png";
  static const just_chatting = "assets/png/top_streams/just_chatting.png";
  static const world_of_war = "assets/png/top_streams/world_of_war.png";
  static const baldurs = "assets/png/top_streams/baldurs.png";

  // game view png/dashboard
  static const category1 = "assets/png/home/category1.png";
  static const category2 = "assets/png/home/category2.png";
  static const heart_image = "assets/png/home/heart_image.png";

  // Trophy screen png/dashboard

  static const rankPerson1 = "assets/png/home/rankPerson1.png";
  static const rankPerson2 = "assets/png/home/rankPerson2.png";
  static const rankPerson3 = "assets/png/home/rankPerson3.png";
  static const rankTrophy1 = "assets/png/home/rankTrophy1.png";
  static const gemstones = "assets/png/home/gemstones.png";
  static const trophyGlobalIcon = "assets/png/home/trophyGlobalIcon.png";

  // Trending screen images

  static const post = "assets/png/trending/ic_post_new.png";
  static const post_logo = "assets/png/trending/post.png";
  static const notification = "assets/png/trending/notification.png";
  static const post_img = "assets/png/trending/post-img.png";
  static const ic_heart = "assets/png/trending/ic_heart.png";
  static const ic_comment = "assets/png/trending/ic_comment.png";
  static const ic_send = "assets/png/trending/ic_send.png";
  static const reel_img = "assets/png/trending/reel_img.png";
  static const reel_comment = "assets/png/trending/reel_comment.png";
  static const reel_music = "assets/png/trending/reel_music.png";
  static const reel_tip = "assets/png/trending/reel_tip.png";
  static const emoji1 = "assets/png/trending/emoji1.png";
  static const emoji2 = "assets/png/trending/emoji2.png";
  static const emoji3 = "assets/png/trending/emoji3.png";
  static const emoji4 = "assets/png/trending/emoji4.png";
  static const reportConfirmation =
      "assets/png/trending/reportConfirmation.png";

  //  single live create sticker sheet png/dashboard

  static const sticker1 = "assets/png/streamer/liveCreate/sticker1.png";
  static const sticker2 = "assets/png/streamer/liveCreate/sticker2.png";
  static const sticker3 = "assets/png/streamer/liveCreate/sticker3.png";
  static const sticker4 = "assets/png/streamer/liveCreate/sticker4.png";
  static const sticker5 = "assets/png/streamer/liveCreate/sticker5.png";
  static const sticker6 = "assets/png/streamer/liveCreate/sticker6.png";
  static const sticker7 = "assets/png/streamer/liveCreate/sticker7.png";
  static const sticker8 = "assets/png/streamer/liveCreate/sticker8.png";
  static const sticker9 = "assets/png/streamer/liveCreate/sticker9.png";
  static const sticker10 = "assets/png/streamer/liveCreate/sticker10.png";
  static const sticker11 = "assets/png/streamer/liveCreate/sticker11.png";
  static const sticker12 = "assets/png/streamer/liveCreate/sticker12.png";
  static const sticker13 = "assets/png/streamer/liveCreate/sticker13.png";
  static const sticker14 = "assets/png/streamer/liveCreate/sticker14.png";
  static const sticker15 = "assets/png/streamer/liveCreate/sticker15.png";
  static const arrowDown = "assets/png/streamer/liveCreate/arrowDown.png";

  // single live create background image:

  static const background1 = "assets/png/streamer/liveCreate/background1.png";
  static const background2 = "assets/png/streamer/liveCreate/background2.png";
  static const background3 = "assets/png/streamer/liveCreate/background3.png";
  static const background4 = "assets/png/streamer/liveCreate/background4.png";
  static const background5 = "assets/png/streamer/liveCreate/background5.png";
  static const background6 = "assets/png/streamer/liveCreate/background6.png";
  static const background7 = "assets/png/streamer/liveCreate/background7.png";
  static const background8 = "assets/png/streamer/liveCreate/background8.png";
  static const background9 = "assets/png/streamer/liveCreate/background9.png";
  static const background10 = "assets/png/streamer/liveCreate/background10.png";
  static const background11 = "assets/png/streamer/liveCreate/background11.png";
  static const background12 = "assets/png/streamer/liveCreate/background12.png";
  static const background13 = "assets/png/streamer/liveCreate/background13.png";
  static const background14 = "assets/png/streamer/liveCreate/background14.png";

  // filter screen png/dashboard

  static const filter1 = "assets/png/streamer/liveCreate/filter1.png";
  static const filter2 = "assets/png/streamer/liveCreate/filter2.png";
  static const filter3 = "assets/png/streamer/liveCreate/filter3.png";
  static const filter4 = "assets/png/streamer/liveCreate/filter4.png";
  static const filter5 = "assets/png/streamer/liveCreate/filter5.png";
  static const filter6 = "assets/png/streamer/liveCreate/filter6.png";
  static const filter7 = "assets/png/streamer/liveCreate/filter7.png";
  static const filter8 = "assets/png/streamer/liveCreate/filter8.png";
  static const filter9 = "assets/png/streamer/liveCreate/filter9.png";
  static const filter10 = "assets/png/streamer/liveCreate/filter10.png";
  static const filter11 = "assets/png/streamer/liveCreate/filter11.png";
  static const filter12 = "assets/png/streamer/liveCreate/filter12.png";
  static const filter13 = "assets/png/streamer/liveCreate/filter13.png";
  static const filter14 = "assets/png/streamer/liveCreate/filter14.png";

  // beauty screen png/dashboard

  static const facey = "assets/png/streamer/liveCreate/facey.png";
  static const eyes = "assets/png/streamer/liveCreate/eyes.png";
  static const touchup = "assets/png/streamer/liveCreate/touchup.png";
  static const buffering = "assets/png/streamer/liveCreate/buffering.png";

  // filter word sheet

  static const deleteIcon = "assets/png/streamer/liveStreamer/deleteIcon.png";
  static const musicIcon = "assets/png/streamer/liveStreamer/musicIcon.png";

  // data sheet
  static const graph = "assets/png/streamer/liveStreamer/graph.png";
  static const views = "assets/png/streamer/liveStreamer/views.png";

  // screen sharing sheet

  static const whatsApp = "assets/png/streamer/liveStreamer/whatsApp.png";
  static const Facebook = "assets/png/streamer/liveStreamer/facebook.png";
  static const twitter = "assets/png/streamer/liveStreamer/twitter.png";
  static const messenger = "assets/png/streamer/liveStreamer/messenger.png";
  static const Instagram = "assets/png/streamer/liveStreamer/instagram.png";
  static const telegram = "assets/png/streamer/liveStreamer/telegram.png";
  static const contacts = "assets/png/streamer/liveStreamer/contacts.png";
  static const others = "assets/png/streamer/liveStreamer/others.png";
  static const download = "assets/png/streamer/liveStreamer/download.png";
  static const dislike = "assets/png/streamer/liveStreamer/dislike.png";
  static const report = "assets/png/streamer/liveStreamer/report.png";

  // end screen png/dashboard

  static const twIcon = "assets/png/streamer/liveStreamer/twIcon.png";
  static const tIcon = "assets/png/streamer/liveStreamer/tIcon.png";
  static const fIcon = "assets/png/streamer/liveStreamer/fIcon.png";

  // multi guest streamer extra sheet png/dashboard

  static const boost = "assets/png/streamer/multiGuestStreamer/boostIcon.png";

  // chat screen png/dashboard

  static const chatScreenIcon = "assets/png/Chat/chatScreenIcon.png";
  static const deleteCrossIcon = "assets/png/Chat/deleteCrossIcon.png";
  static const star = "assets/png/Chat/star.png";
  static const chatCamera = "assets/png/Chat/chatCamera.png";
  static const chatPhoto = "assets/png/Chat/chatPhoto.png";
  static const chatMic = "assets/png/Chat/chatMic.png";

  // user dashboard png/dashboard

  static const share = "assets/png/userProfile/share.png";
  static const message = "assets/png/userProfile/message.png";
  static const blue_tick = "assets/png/userProfile/blue_tick.png";
  static const live = "assets/png/userProfile/live.png";
  static const user = "assets/png/userProfile/user.png";
  static const play = "assets/png/userProfile/play.png";
  static const kIcon = "assets/png/userProfile/kIcon.png";
  static const layerIcon = "assets/png/userProfile/layerIcon.png";
  static const mobileButton = "assets/png/userProfile/mobileButton.png";
  static const moonIcon = "assets/png/userProfile/moonIcon.png";
  static const settingIcon = "assets/png/userProfile/settingIcon.png";
  static const tile1 = "assets/png/userProfile/tile1.png";
  static const tile2 = "assets/png/userProfile/tile2.png";
  static const wallet = "assets/png/userProfile/wallet.png";
  static const gem = "assets/png/userProfile/gem.png";
  static const store = "assets/png/userProfile/store.png";
  static const transactionIcon = "assets/png/userProfile/transaction.png";
  static const bagIcon = "assets/png/userProfile/bag.png";
  static const levelIcon = "assets/png/userProfile/level.png";
  static const fansIcon = "assets/png/userProfile/fans.png";
  static const subscriptionIcon = "assets/png/userProfile/subscription.png";
  static const subscriberIcon = "assets/png/userProfile/subscriber.png";
  static const verifiedMember = "assets/png/userProfile/verified_member.png";

// streamer dashboard png/dashboard

  static const yellow_tick = "assets/png/streamerProfile/yellow_tick.png";
  static const edit_profile = "assets/png/streamerProfile/edit_profile.png";
  static const editTextIcon = "assets/png/streamerProfile/editTextIcon.png";
  static const dropDownIcon = "assets/png/streamerProfile/dropDownIcon.png";

  // setting screen images

  static const insecure = "assets/png/setting/insecure.png";
  static const phone = "assets/png/setting/phone.png";
  static const email = "assets/png/setting/email.png";
  static const changePassword = "assets/png/setting/changePassword.png";
  static const loginMethod = "assets/png/setting/loginMethod.png";
  static const selfBan = "assets/png/setting/selfBan.png";
  static const succeed = "assets/png/setting/succeed.png";
  static const changeEmail = "assets/png/setting/changeEmail.png";
  static const changePasswordImage =
      "assets/png/setting/changePasswordImage.png";
  static const gIcon = "assets/png/setting/gIcon.png";

  // room decor

  static const roomDecor1 = "assets/png/room_decor/room_decor_1.png";
  static const roomDecor2 = "assets/png/room_decor/room_decor_2.png";
  static const roomDecor3 = "assets/png/room_decor/room_decor_3.png";
  static const roomDecor4 = "assets/png/room_decor/room_decor_4.png";
  static const roomDecor5 = "assets/png/room_decor/room_decor_5.png";
  static const roomDecor6 = "assets/png/room_decor/room_decor_6.png";
  static const roomDecor7 = "assets/png/room_decor/room_decor_7.png";

  // avatar frame

  static const avatarFrameOrange =
      "assets/svg/avatar_frame/avatar_frame_orange.svg";
  static const avatarFrameWhite =
      "assets/svg/avatar_frame/avatar_frame_white.svg";
  static const avatarFramePurple1 =
      "assets/svg/avatar_frame/avatar_frame_purple1.svg";
  static const avatarFramePurple2 =
      "assets/svg/avatar_frame/avatar_frame_purple2.svg";

  static const micOff = "assets/png/mic_off.png";
  static const micOn = "assets/png/mic_on.png";

  // new assets

  static const icOg = "assets/png/new/ic_og.png";
  static const icLive = "assets/png/new/ic_live.png";
  static const icVerified = "assets/png/new/ic_verified.png";
  static const icNotification = "assets/png/new/ic_notificaiton.png";
  static const icSettings = "assets/png/new/ic_settings.png";
  static const icLeft = "assets/png/new/ic_left.png";
  static const icBookmark = "assets/png/new/ic_bookmark.png";
  static const icEdit = "assets/png/new/ic_edit.png";
  static const icHeartAdd = "assets/png/new/ic_heart_add.png";
  static const icMenu = "assets/png/new/ic_menu.png";
  static const icLink = "assets/png/new/ic_link.png";
  static const icCloud = "assets/png/new/ic_cloud.png";
  static const icFemaleGender = "assets/png/new/ic_female_gender.png";
  static const icMaleGender = "assets/png/new/ic_male_gender.png";
  static const icCamera = "assets/png/new/ic_camera.png";

  static const icReelLive = "assets/png/new/ic_reel_live.png";
  static const icShare = "assets/png/new/ic_share.png";
  static const icComment = "assets/png/new/ic_comment.png";
  static const icMusic = "assets/png/new/ic_music.png";
  static const icAudio = "assets/png/new/ic_audio.png";
  static const icSave = "assets/png/new/ic_save.png";

  static const giftAnimation = "assets/animations/gift_button.json";

  static const icLiveSettings = "assets/png/new/ic_live_settings.png";
  static const icLogo = "assets/png/new/ic_logo.png";
  static const icBattle = "assets/png/new/ic_battle.png";
  static const icInvite = "assets/png/new/ic_invite.png";

  static const String verifiedBadge = "assets/png/new/ic_verified_badge.png";
  static const String verifiedSuccess =
      "assets/png/new/ic_verified_success.png";
  static const String checkList = "assets/png/new/ic_check_list.png";
  static const String icViews = "assets/png/new/ic_views.png";

  static const String icReelHeart = "assets/png/new/ic_reel_heart.png";
  static const String icReelPlay = "assets/png/new/ic_reel_play.png";

  static const String icRank1 = "assets/png/new/ic_rank_1.png";
  static const String icRank2 = "assets/png/new/ic_rank_2.png";
  static const String icRank3 = "assets/png/new/ic_rank_3.png";
  static const String icKing = "assets/svg/ic_king.svg";

  /// Profile dashboard tile icons (HD SVG)
  static const String dashboardWalletIconSvg = "assets/svg/Wallet.svg";
  static const String dashboardTransactionIconSvg = "assets/svg/trans.svg";
  static const String dashboardBagIconSvg = "assets/svg/Bag.svg";
  static const String dashboardLevelIconSvg = "assets/svg/level.svg";
  static const String dashboardTopFansIconSvg = "assets/svg/fans.svg";
  static const String dashboardStoreIconSvg = "assets/svg/store.svg";
  static const String dashboardSubscriptionIconSvg = "assets/svg/subscribtion.svg";
  static const String dashboardSubscriberIconSvg = "assets/svg/subscriber.svg";
  static const String dashboardSettingsIconSvg =
      "assets/svg/settings_dashboard.svg";
}

const String darkIcon = "assets/png/dashboard/darkIcon.png";
const String mars = "assets/png/dashboard/mars.png";
const String pakistan = "assets/png/dashboard/pakistan.png";
const String nav = "assets/png/dashboard/Nav.png";
const String icon1 = "assets/png/dashboard/icon1.png";
const String img = "assets/png/dashboard/img_20240317_203747.png";
const String walletIcon = "assets/png/dashboard/wallet_icon.png";
const String walletTile = "assets/png/dashboard/wallet_tile.png";
const String storeIcon = "assets/png/dashboard/store_icon.png";
const String storeTile = "assets/png/dashboard/store_tile.png";
const String transaction = "assets/png/dashboard/transaction.png";
const String bag = "assets/png/dashboard/bag.png";
const String level = "assets/png/dashboard/level.png";
const String topfans = "assets/png/dashboard/topFans.png";
const String subscription = "assets/png/dashboard/subscription.png";
const String subscriber = "assets/png/dashboard/subscrption.png";
const String coin = "assets/png/dashboard/coin.png";
const String transactionIcon = "assets/png/dashboard/transaIcon.png";
const String back = "assets/png/dashboard/back.png";
const String paypal = "assets/png/dashboard/paypal.png";
const String helcium = "assets/png/dashboard/helcium.png";
const String xe = "assets/png/dashboard/xe.png";
const String stripe = "assets/png/dashboard/stripe.png";
const String wise = "assets/png/dashboard/wise.png";
const String venmo = "assets/png/dashboard/venmo.png";
const String check = "assets/png/dashboard/check.png";
const String avatar = "assets/png/dashboard/avatar.png";
const String gift = "assets/png/dashboard/gift.png";
const String storeCover = "assets/png/dashboard/store_cover.png";
const String room = "assets/png/dashboard/room.png";
const String chat = "assets/png/dashboard/chat.png";
const String batch = "assets/png/dashboard/batch.png";
const String incomeIcon = "assets/png/dashboard/income.png";
const String outGoIcon = "assets/png/dashboard/outgo.png";
const String ride = "assets/png/dashboard/ride.png";
const String heart = "assets/png/dashboard/heart.png";
const String castle = "assets/png/dashboard/castle.png";
const String star = "assets/png/dashboard/star.png";
const String ribon = "assets/png/dashboard/ribon.png";
const String chest = "assets/png/dashboard/Chest.png";
const String levelCover = "assets/png/dashboard/level_cover.png";
const String badge = "assets/png/dashboard/badge.png";
const String diamond = "assets/png/dashboard/diamond.png";
const String diamond1 = "assets/png/dashboard/diamon.png";
const String celebration = "assets/png/dashboard/celebration.png";
const String upload = "assets/png/dashboard/upload.png";

class SubLists {
  static final List<String> categoryItems = [
    "Explore",
    "Popular",
    "Battle",
    "Games",
  ];
}

class Dimension {
  static final double borderRadius = 35.r;

  //padding
}

Color amberColor = AppColors.primaryColor;

enum CheckoutEnum {
  paypal,
  venmo,
  stripe,
  xe,
  wise,
  helcim,
}
