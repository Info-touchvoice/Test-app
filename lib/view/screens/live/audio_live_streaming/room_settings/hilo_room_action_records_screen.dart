import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tiki/services/room_action_records_store.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view_model/live_controller.dart';

class HiloRoomActionRecordsScreen extends StatefulWidget {
  const HiloRoomActionRecordsScreen({Key? key}) : super(key: key);

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HiloRoomActionRecordsScreen()),
    );
  }

  @override
  State<HiloRoomActionRecordsScreen> createState() =>
      _HiloRoomActionRecordsScreenState();
}

class _HiloRoomActionRecordsScreenState
    extends State<HiloRoomActionRecordsScreen> {
  final LiveViewModel _vm = Get.find();
  int _tabIndex = 0;
  List<RoomActionRecord> _records = [];
  bool _loading = true;

  String get _roomId => _vm.liveStreamingModel.objectId ?? '';

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    final type = _tabIndex == 0
        ? RoomActionRecordType.kickOutMic
        : RoomActionRecordType.kickOutRoom;
    final records = await RoomActionRecordsStore.load(_roomId, type);
    if (mounted) {
      setState(() {
        _records = records;
        _loading = false;
      });
    }
  }

  void _onTabChanged(int index) {
    if (_tabIndex == index) return;
    setState(() => _tabIndex = index);
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Action records',
          style: sfProDisplayMedium.copyWith(
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
            child: _SegmentedTabs(
              selectedIndex: _tabIndex,
              onChanged: _onTabChanged,
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _records.isEmpty
                    ? const _EmptyRecordsIllustration()
                    : RefreshIndicator(
                        onRefresh: _loadRecords,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          itemCount: _records.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          itemBuilder: (_, index) =>
                              _ActionRecordTile(record: _records[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _SegmentedTabs({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _TabChip(
            label: 'Kick out mic',
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _TabChip(
            label: 'Kick out room',
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: sfProDisplayMedium.copyWith(
              fontSize: 13.sp,
              color: selected ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionRecordTile extends StatelessWidget {
  final RoomActionRecord record;

  const _ActionRecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('MMM d, yyyy · HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(record.timestampMs),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(url: record.targetAvatarUrl, name: record.targetUserName),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.targetUserName,
                  style: sfProDisplayMedium.copyWith(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Removed by ${record.actorUserName}',
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  time,
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  final String name;

  const _Avatar({this.url, required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 22.r,
      backgroundColor: const Color(0xFFE8E0F5),
      backgroundImage: url != null && url!.isNotEmpty
          ? CachedNetworkImageProvider(url!)
          : null,
      child: url == null || url!.isEmpty
          ? Text(
              initial,
              style: sfProDisplayMedium.copyWith(
                fontSize: 16.sp,
                color: const Color(0xFF9036FF),
              ),
            )
          : null,
    );
  }
}

class _EmptyRecordsIllustration extends StatelessWidget {
  const _EmptyRecordsIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 160.w,
            height: 120.h,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  left: 20.w,
                  bottom: 8.h,
                  child: _BlobCharacter(
                    color: const Color(0xFF9036FF),
                    size: 72.w,
                    eyeStyle: _BlobEyeStyle.happy,
                  ),
                ),
                Positioned(
                  right: 24.w,
                  bottom: 0,
                  child: _BlobCharacter(
                    color: const Color(0xFFF7BA1C),
                    size: 52.w,
                    eyeStyle: _BlobEyeStyle.wink,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No records yet',
            style: sfProDisplayRegular.copyWith(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

enum _BlobEyeStyle { happy, wink }

class _BlobCharacter extends StatelessWidget {
  final Color color;
  final double size;
  final _BlobEyeStyle eyeStyle;

  const _BlobCharacter({
    required this.color,
    required this.size,
    required this.eyeStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.45),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Eye(isWink: eyeStyle == _BlobEyeStyle.wink),
              SizedBox(width: size * 0.18),
              const _Eye(isWink: false),
            ],
          ),
          SizedBox(height: size * 0.08),
          Container(
            width: size * 0.35,
            height: size * 0.12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(size),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  final bool isWink;

  const _Eye({required this.isWink});

  @override
  Widget build(BuildContext context) {
    if (isWink) {
      return Container(
        width: 10,
        height: 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
