// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class CustomDigitalClock extends StatefulWidget {
  const CustomDigitalClock(this.model);

  final ClockModel model;

  @override
  _CustomDigitalClockState createState() => _CustomDigitalClockState();
}

class _CustomDigitalClockState extends State<CustomDigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(CustomDigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddingValue = MediaQuery.of(context).size.width/9;
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    // second variable
    final second = DateFormat('s').format(_dateTime);
    print("second: $second");
    print("timer : ${_timer.toString()}");
    final fontSize = MediaQuery.of(context).size.width / 6.0;
    final fontSizeTemp = MediaQuery.of(context).size.width / 15.0;

    final offset = -fontSize / 7;
    final temperature = widget.model.temperature;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    final defaultStyleTemp = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSizeTemp,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(5, 0),
        ),
      ],
    );

    return AspectRatio(
      aspectRatio: 5 / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              color: colors[_Element.background],
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _buildTime(hour, minute, defaultStyle, paddingValue),
                        _buildTemp(temperature, defaultStyleTemp)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          _mediumButton(),
          _smallButton()
        ],
      ),
    );
  }

  Widget _mediumButton() {
    return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
          child: Container(
        width: 15.0,
        height: 60.0,
        color: Colors.black,
      ),
    );
  }

  Widget _smallButton() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
          child: Container(
        width: 15.0,
        height: 30.0,
        color: Colors.yellowAccent,
      ),
    );
  }

  Widget _buildGap() {
    return SizedBox(
      width: 10.0,
    );
  }

  // widget for time
  Widget _buildTime(
      final hourValue, final minuteValue, TextStyle timeTextStyle, double padding) {
    Widget time;
    time = DefaultTextStyle(
      style: timeTextStyle,
      child: Container(
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(hourValue),
            _buildGap(),
            Text(":"),
            _buildGap(),
            Text(minuteValue),
          ],
        ),
      ),
    );

    return time;
  }

  // widget for temperature
  Widget _buildTemp(final temp, TextStyle tempTextStyle) {
    return DefaultTextStyle(style: tempTextStyle, child: Text("$temp °C"));
  }
}
