import 'package:example/resources/app_colors.dart';
import 'package:example/resources/app_texts.dart';
import 'package:example/router/app_router.dart';
import 'package:example/ume/core/plugin_manager.dart';
import 'package:example/ume/core/ui/root_widget.dart';
import 'package:example/ume/kit_perf/flutter_ume_kit_perf.dart';
import 'package:example/ume/kit_ui/flutter_ume_kit_ui.dart';
import 'package:example/ume/show_code/flutter_ume_kit_show_code.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  initUme();
  runApp(const UMEWidget(
    enable: true,
    child: MyApp(),
  ));
}

void initUme() {
  PluginManager.instance
    ..register(Performance())
    ..register(const MemoryInfoPage())
    ..register(AlignRuler())
    ..register(const WidgetInfoInspector())
    ..register(const ShowCode());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp.router(
        title: AppTexts.appName,
        theme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            textTheme: GoogleFonts.assistantTextTheme(
              Theme.of(context).textTheme.apply(
                    bodyColor: AppColors.mainTextColor3,
                  ),
            ),
            scaffoldBackgroundColor: AppColors.pageBackground),
        routerConfig: appRouterConfig,
      ),
    );
  }
}
