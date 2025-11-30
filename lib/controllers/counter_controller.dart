import 'package:get/get.dart';

class CounterController extends GetxController {
  var count = 0.obs;

  void increase() => count++;
  void reset() => count.value = 0;
}
