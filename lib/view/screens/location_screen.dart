import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart' as LocationForAll;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:tiki/data/app/setup.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/ui/text_with_tap.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';

import '../../utils/theme/colors_constant.dart';
import '../widgets/custom_buttons.dart';

// ignore: must_be_immutable
class LocationScreen extends StatefulWidget {
  static const String route = '/location';

  LocationScreen({this.currentUser});

  UserModel? currentUser;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Future<void> _determinePosition() async {
    print("Location: _determinePosition clicked");

    LocationForAll.Location location = LocationForAll.Location();

    bool _serviceEnabled;
    LocationForAll.PermissionStatus _permissionGranted;
    LocationForAll.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        QuickHelp.showAppNotificationAdvanced(
            title: "permissions.location_not_supported".tr(),
            message: "permissions.add_location_manually"
                .tr(namedArgs: {"app_name": Setup.appName}),
            context: context);

        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == LocationForAll.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted == LocationForAll.PermissionStatus.granted ||
          _permissionGranted ==
              LocationForAll.PermissionStatus.grantedLimited) {
        QuickHelp.showLoadingDialog(context);

        _locationData = await location.getLocation();
        goHome(_locationData);
      } else if (_permissionGranted == LocationForAll.PermissionStatus.denied) {
        QuickHelp.showAppNotificationAdvanced(
            title: "permissions.location_access_denied".tr(),
            message: "permissions.location_explain"
                .tr(namedArgs: {"app_name": Setup.appName}),
            context: context);
      } else if (_permissionGranted ==
          LocationForAll.PermissionStatus.deniedForever) {
        QuickHelp.showAppNotificationAdvanced(
            title: "permissions.enable_location".tr(),
            message: "permissions.location_access_denied_explain"
                .tr(namedArgs: {"app_name": Setup.appName}),
            context: context);
      }
    } else if (_permissionGranted ==
        LocationForAll.PermissionStatus.deniedForever) {
      _permissionDeniedForEver();
    } else if (_permissionGranted == LocationForAll.PermissionStatus.granted ||
        _permissionGranted == LocationForAll.PermissionStatus.grantedLimited) {
      QuickHelp.showLoadingDialog(context);

      _locationData = await location.getLocation();
      goHome(_locationData);
    }
  }

  _permissionDeniedForEver() {
    QuickHelp.showDialogPermission(
        context: context,
        title: "permissions.location_access_denied".tr(),
        confirmButtonText: "permissions.okay_settings".tr().toUpperCase(),
        message: "permissions.location_access_denied_explain"
            .tr(namedArgs: {"app_name": Setup.appName}),
        onPressed: () async {
          QuickHelp.hideLoadingDialog(context);

          QuickHelp.showAppNotificationAdvanced(
              title: "permissions.enable_location".tr(),
              message: "permissions.location_access_denied_explain"
                  .tr(namedArgs: {"app_name": Setup.appName}),
              context: context);
        });
  }

  goHome(LocationForAll.LocationData locationData) async {
    print("Location ${locationData.latitude}, ${locationData.longitude}");

    if (!widget.currentUser!.getLocationTypeNearBy!) {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.goBackToPreviousPage(context, result: widget.currentUser);

      /* QuickHelp.goToNavigatorScreen(
          context,
          HomeScreen(
            currentUser: widget.currentUser,
          ), back: false,
        finish: true
      );*/
      //return;
    } else {
      print("Location getAddressFromLatLong");

      getAddressFromLatLong(locationData);
    }
  }

  Future<void> getAddressFromLatLong(
      LocationForAll.LocationData position) async {
    ParseGeoPoint parseGeoPoint = new ParseGeoPoint();
    parseGeoPoint.latitude = position.latitude!;
    parseGeoPoint.longitude = position.longitude!;

    widget.currentUser!.setHasGeoPoint = true;
    widget.currentUser!.setGeoPoint = parseGeoPoint;

    /*if(QuickHelp.isMobile()){

      List<Placemark>? placements;
      placements = await placemarkFromCoordinates(position.latitude!, position.longitude!);
      print(placements);

      Placemark place = placements[0];
      //Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

      widget.currentUser!.setLocation = "${place.locality}, ${place.country}";
      widget.currentUser!.setCity = "${place.locality}";
    }*/

    ParseResponse parseResponse = await widget.currentUser!.save();

    if (parseResponse.success) {
      widget.currentUser = parseResponse.results!.first as UserModel;

      QuickHelp.hideLoadingDialog(context);
      QuickHelp.goBackToPreviousPage(context, result: widget.currentUser);

      QuickHelp.showAppNotificationAdvanced(
        context: context,
        user: widget.currentUser,
        title: "permissions.location_updated".tr(),
        message: "permissions.location_updated_explain".tr(),
        isError: false,
      );

      /* QuickHelp.goToNavigatorScreen(
          context,
          HomeScreen(
            currentUser: widget.currentUser,
          ), back: false, finish: true);*/
    } else {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.goBackToPreviousPage(context);

      QuickHelp.showAppNotificationAdvanced(
        context: context,
        user: widget.currentUser,
        title: "permissions.location_updated_null".tr(),
        message: "permissions.location_updated_null_explain".tr(),
        isError: true,
      );
    }
  }

  Future<bool> _onBackPressed() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //QuickHelp.setWebPageTitle(context, "page_title.location_title".tr());

    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: BaseScaffold(
        body: body(),
      ),
    );
  }

  Widget body() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(),
            ],
          ),
          Container(
            child: Icon(
              Icons.location_on_outlined,
              color: Color(0xFFFFC107),
              size: 200,
            ),
          ),
          Column(
            children: [
              TextWithTap(
                "permissions.enable_location".tr(),
                marginTop: 20,
                fontSize: 25,
                marginBottom: 5,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFC107),
              ),
              TextWithTap(
                "permissions.location_explain"
                    .tr(namedArgs: {"app_name": Setup.appName}),
                textAlign: TextAlign.center,
                marginTop: 0,
                fontSize: 14,
                marginBottom: 5,
                marginLeft: 50,
                marginRight: 50,
                color: Color(0xFF989898),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: PrimaryButton(
                  title: "permissions.allow_location".tr().toUpperCase(),
                  onTap: () {
                    _determinePosition();
                  },
                  gradient: AppColors.secondaryGradient(stops: [0.0, 1.0]),
                  borderRadius: 55,
                ),
              ),
              TextWithTap(
                "permissions.location_tell_more".tr(),
                textAlign: TextAlign.center,
                marginTop: 0,
                fontSize: 14,
                marginBottom: 20.h,
                marginLeft: 50,
                marginRight: 50,
                color: Color(0xFF989898),
                onTap: () {
                  QuickHelp.showDialogPermission(
                      context: context,
                      confirmButtonText:
                          "permissions.allow_location".tr().toUpperCase(),
                      title: "permissions.meet_people".tr(),
                      message: "permissions.meet_people_explain".tr(),
                      onPressed: () async {
                        QuickHelp.hideLoadingDialog(context);

                        _determinePosition();
                      });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
