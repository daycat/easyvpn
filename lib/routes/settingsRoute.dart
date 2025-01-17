//ignore_for_file: file_names
import 'dart:io';

import 'package:easyvpn/widgets/AboutListTile.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../model/themeCollection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  int connectionValue = 0;
  bool killSwitch = false, proVpn = false, notifySwitch = false;
  List<String> connectionModes = ['OpenVPN', 'IPSec', 'ISSR'];

  setConnectionValue(int? value) {
    setState(() {
      connectionValue = value!;
    });
  }

  Column listTileSet(String title, String description, bool value,
          Function(bool)? onChanged) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(color: Colors.grey, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title,
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1!
                  .copyWith(color: Colors.grey)),
        ),
        SwitchListTile(
            activeColor: Theme.of(context).accentColor,
            inactiveTrackColor:
                Provider.of<ThemeCollection>(context).isDarkActive
                    ? const Color(0xff38323F)
                    : const Color(0xffD7D6D9),
            contentPadding: EdgeInsets.zero,
            title: Text(
              description,
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
            value: value,
            onChanged: onChanged)
      ]);

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeCollection>(context);
    return Scaffold(
      // appBar: AppBar(
      //   shadowColor: Colors.transparent,
      //   title: const Text('Settings'),
      // ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        children: [
          // Text('Connection Mode',
          //     style: Theme.of(context)
          //         .primaryTextTheme
          //         .subtitle1!
          //         .copyWith(color: Colors.grey)),
          // const SizedBox(height: 4),
          // Column(
          //     children: connectionModes.map((e) {
          //   return ListTile(
          //     contentPadding: EdgeInsets.zero,
          //     title: Text(
          //       e,
          //       style: Theme.of(context).primaryTextTheme.subtitle1,
          //     ),
          //     trailing: Radio(
          //         fillColor: MaterialStateProperty.all(
          //           connectionModes[connectionValue] != e
          //               ? themeData.isDarkActive
          //                   ? Colors.white70
          //                   : Colors.grey
          //               : Theme.of(context).accentColor,
          //         ),
          //         value: connectionModes.indexOf(e),
          //         groupValue: connectionValue,
          //         onChanged: setConnectionValue),
          //   );
          // }).toList()),
          // listTileSet(
          //     'Kill Switch',
          //     'Block internet when connecting or changing servers',
          //     killSwitch,
          //     (value) => setState(() => killSwitch = value)),
          // listTileSet('Connection', 'Connect when Pro VPN starts', proVpn,
          //     (value) => setState(() => proVpn = value)),
          // listTileSet(
          //     'Notification',
          //     'Show notification when Prime VPN is not connected.',
          //     notifySwitch,
          //     (value) => setState(() => notifySwitch = value)),
          Platform.isAndroid
              ? ListTile(
                  // tileColor: AppColors.BLACK,
                  title: Text(
                    '忽略电池优化',
                    style: Theme.of(context).primaryTextTheme.subtitle1,
                  ),
                  // leading: Icon(
                  //   Icons.battery_saver,
                  //   color: Colors.white,
                  //   size: 30.sp,
                  // ),
                  onTap: () async {
                    if (Platform.isAndroid) {
                      var hasPermissions =
                          await FlutterBackground.hasPermissions;
                      if (!hasPermissions) {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  // title: Text(S
                                  //     .of(context)
                                  //     .background_operation_dialog_title),
                                  content: Text('忽略电池优化有效防止意外断线'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await FlutterBackground.initialize();
                                      },
                                      child: Text('确定'),
                                    ),
                                  ]);
                            });
                      } else {
                        Scaffold.of(context).showSnackBar(
                            new SnackBar(content: new Text('已忽略电池优化')));
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(
                          new SnackBar(content: new Text('暂不支持忽略电池优化')));
                    }
                  }, //........................................
                )
              : SizedBox(),
          listTileSet('暗夜模式', '减少眩光，改善夜间视野。', themeData.isDarkActive, (value) {
            themeData.setDarkTheme(value);
          }),
        ],
      ),
    );
  }
}
