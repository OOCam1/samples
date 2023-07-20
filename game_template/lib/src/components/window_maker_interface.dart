import 'window.dart';

abstract class WindowMaker {
  static late double angleOfView;

//where is the camera if 0 is on the floor and pi is directly above city
  static void setAngleOfView(double angle) {
    angleOfView = angle;
  }

  Set<Window> getWindows(double viewedHeight, double buildingHalfWidth);
}
