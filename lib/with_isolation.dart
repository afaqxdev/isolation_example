// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

class WithIsolation extends StatelessWidget {
  const WithIsolation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images1.gif',
              scale: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  var total = complexTask1();
                  print("result1:${total.toString()}");
                },
                child: Text("With Out Isolate")),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  final receivePort = ReceivePort();
                  Isolate.spawn(complexTask2, receivePort.sendPort);
                  receivePort.listen((total) {
                    print("result2: ${total.toString()}");
                    receivePort.close();
                  });
                },
                child: const Text("With Isolate")),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Task3")),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  double complexTask1() {
    var total = 0.0;
    for (int i = 0; i < 1000000000; i++) {
      total += 1;
    }
    return total;
  }
}

complexTask2(SendPort sendPort) {
  var total = 0.0;
  for (int i = 0; i < 1000000000; i++) {
    total += 1;
  }
  sendPort.send(total);
}
