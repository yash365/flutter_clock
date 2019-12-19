import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import 'custom_digital_clock.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    runApp(ClockCustomizer((ClockModel model) => CustomDigitalClock(model)));

}
