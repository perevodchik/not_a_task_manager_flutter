import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomTimePicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomTimePicker({DateTime? currentTime, LocaleType? locale}): super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    var m = this.currentTime.minute;
    var middleIndex = 0;

    if(m >= 0 && m < 30)
      middleIndex = 0;
    else if(m >= 30 && m < 59)
      middleIndex = 1;
    else
      middleIndex = 2;

    setLeftIndex(this.currentTime.hour);
    setMiddleIndex(middleIndex);
    setRightIndex(0);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if(index == 0) {
      return '0';
    }
    else if(index == 1) {
      return '30';
    }
    else if(index == 2) {
      return '59';
    }
    else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    return null;
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }

  int convertIndexToQuarter(int index){
    if(index == 0) {
      return 0;
    }
    else if(index == 1) {
      return 30;
    }
    else if(index == 2) {
      return 59;
    }
    else {
      return 0;
    }
  }

  @override
  DateTime finalTime() {
    DateTime time = currentTime.add(Duration(days: currentLeftIndex()));
    var hour = currentLeftIndex();
    var minute = convertIndexToQuarter(currentMiddleIndex());
    return currentTime.isUtc
        ? DateTime.utc(time.year, time.month, time.day, hour, minute)
        : DateTime(time.year, time.month, time.day, hour, minute);
  }
}