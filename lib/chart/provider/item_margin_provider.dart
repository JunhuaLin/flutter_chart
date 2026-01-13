/// FileName item_margin_provider
///
/// @Author junhua
/// @Date 2024/4/7
/// @Description item间距提供者
/// 在k线图时，缩放中item间距会变化，其他场景下不需要
class ItemMarginProvider {
  ItemMarginProviderFun setItemMargin;

  ItemMarginProvider(this.setItemMargin);
}

typedef ItemMarginProviderFun = double Function(double displayCount, double contentWidth);
