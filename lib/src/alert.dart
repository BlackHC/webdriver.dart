// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of webdriver;

/// A JavaScript alert(), confirm(), or prompt() dialog
class Alert extends _WebDriverBase {
  /// The text of the JavaScript alert(), confirm(), or prompt() dialog.
  final String text;

  Alert._(this.text, driver) : super(driver, '');

  /// Accepts the currently displayed alert (may not be the alert for which this
  /// object was created).
  ///
  ///  Throws [NoSuchAlertException] if there isn't currently an alert.
  Future accept() async {
    await _post('accept_alert');
  }

  /// Dismisses the currently displayed alert (may not be the alert for which
  /// this object was created).
  ///
  ///  Throws [NoSuchAlertException] if there isn't currently an alert.
  Future dismiss() async {
    await _post('dismiss_alert');
  }

  /// Sends keys to the currently displayed alert (may not be the alert for
  /// which this object was created).
  ///
  /// Throws [NoSuchAlertException] if there isn't currently an alert
  Future sendKeys(String keysToSend) async {
    await _post('alert_text', {'text': keysToSend});
  }

  @override
  String toString() => '$driver.switchTo.alert[$text]';
}
