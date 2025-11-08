import 'dart:async';
import 'dart:io';

import './Design/loadingText.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppCheckExample extends StatefulWidget {
  const AppCheckExample({Key? key}) : super(key: key);

  @override
  State<AppCheckExample> createState() => _AppCheckExampleState();
}

class _AppCheckExampleState extends State<AppCheckExample> {
  List<AppInfo>? installedApps;

  @override
  void initState() {
    getInstalledApps();
    super.initState();
  }

  Future<void> getInstalledApps() async {
    try {
      AppInfo? app = await InstalledApps.getAppInfo("com.example.solarmate");
      final List<AppInfo>? apps = await InstalledApps.getInstalledApps(
        excludeSystemApps: false,
        excludeNonLaunchableApps: true,
        withIcon: true,
      );
      setState(() {
        installedApps = apps;
        print(app);
      });
    } catch (e, st) {
      debugPrint('Error fetching installed apps: $e');
      debugPrintStack(stackTrace: st);
      setState(() {
        installedApps = <AppInfo>[];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return installedApps != null && installedApps!.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 15, 12, 12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),

              child: GridView.builder(
                itemCount: installedApps!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final app = installedApps![index];
                  return GestureDetector(
                    onTap: () {
                      InstalledApps.startApp(app.packageName).then((_) {
                        debugPrint("${app.name ?? app.packageName} launched!");
                      });
                      // later: launch app here
                    },
                    onLongPress: () {
                      InstalledApps.openSettings(app.packageName);
                      // later: show options (e.g., uninstall, details)
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.all(16),
                          child: app.icon != null
                              ? Image.memory(app.icon!, width: 40, height: 40)
                              : const Icon(Icons.apps),
                        ),
                        SizedBox(height: 8),
                        Text(
                          app.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        : Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 15, 12, 12),
            ),

            child: Center(child: LoadingText()),
          );
  }
}
