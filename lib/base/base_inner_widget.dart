import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/common_function.dart';
import 'package:flutter_base_widget/network/api.dart';

///通常是和 viewpager 联合使用  ， 类似于Android 中的 fragment
/// 不过生命周期 还需要在容器父类中根据tab切换来完善
abstract class BaseInnerWidget extends StatefulWidget {
  BaseInnerWidgetState baseInnerWidgetState;
  int index;
  @override
  BaseInnerWidgetState createState() {
    baseInnerWidgetState = getState();
    index = setIndex();
    return baseInnerWidgetState;
  }

  ///作为内部页面 ， 设置是第几个页面 ，也就是在list中的下标 ， 方便 生命周期的完善
  int setIndex();
  BaseInnerWidgetState getState();
  String getStateName() {
    return baseInnerWidgetState.getClassName();
  }
}

abstract class BaseInnerWidgetState<T extends BaseInnerWidget> extends State<T>
    with AutomaticKeepAliveClientMixin, BaseFuntion {
  @override
  void initState() {
    initBaseCommon(this, context);
    setBackIconHinde();
    setTopBarVisible(false);
    setAppBarVisible(false);
    onCreate();
    onResume();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    bottomVsrtical = getVerticalMargin();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: getBaseView(context),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestory();
    HttpManager.cancelHttp(getClassName()); //取消网络请求
    super.dispose();
  }

  ///返回作为内部页面，垂直方向 头和底部 被占用的 高度
  double getVerticalMargin();

  @override
  bool get wantKeepAlive => true;

  ///为了完善生命周期而特意搞得 方法 ， 手动调用 onPause 和onResume
  void changePageVisible(int index, int preIndex) {
    if (index != preIndex) {
      if (preIndex == widget.index) {
        onPause();
      } else if (index == widget.index) {
        onResume();
      }
    }
  }
}
