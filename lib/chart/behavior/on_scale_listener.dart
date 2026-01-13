/// FileName scale_listener
///
/// @Author junhua
/// @Date 2024/3/4
abstract class OnScaleListener {
  void onScaleStart(double centerX, double centerY);

  /// 水平缩放时的回调
  void onScaleUpdate(double currentScale);

  /// 水平缩放结束时的回调
  void onScaleEnd();
}
