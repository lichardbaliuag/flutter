// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/integration_test_driver.dart';
import 'package:vortex_uni_beta/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('scrolling performance test', () {
    testWidgets('measure', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final Finder stockList = find.byValueKey('stock-list');
      expect(stockList, findsOneWidget);

      final timeline = await tester.runAsync(() async {
        final Timeline timeline = await tester.traceAction(() async {
          // Scroll down
          for (int i = 0; i < 5; i++) {
            await tester.drag(stockList, const Offset(0.0, -300.0));
            await tester.pumpAndSettle(const Duration(milliseconds: 500));
          }

          // Scroll up
          for (int i = 0; i < 5; i++) {
            await tester.drag(stockList, const Offset(0.0, 300.0));
            await tester.pumpAndSettle(const Duration(milliseconds: 500));
          }
        });
        return timeline;
      });

      final TimelineSummary summary = TimelineSummary.summarize(timeline);
      await summary.writeTimelineToFile('stocks_scroll_perf', pretty: true);
    }, timeout: Timeout.none);
  });
}
