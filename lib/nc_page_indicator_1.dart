import 'package:flutter/material.dart';

///
///Author: YoungChan
///Date: 2019/8/27 17:13
///Description: PageView 指示器
///

class NCPageIndicator1 extends StatefulWidget {
  final int count;
  final PageController controller;
  final EdgeInsets padding;
  final Color color;
  NCPageIndicator1({
    Key key,
    this.count = 0,
    this.color = Colors.blue,
    @required this.controller,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 24),
  })  : assert(controller != null),
        super(key: key);

  @override
  _NCPageIndicator1State createState() {
    return _NCPageIndicator1State();
  }
}

class _NCPageIndicator1State extends State<NCPageIndicator1>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  void _onIndexChanged() {
    var page = widget.controller.page.round();

    if (page != _currentIndex) {
      setState(() {
        _currentIndex = page;
      });
    }
  }

  @override
  void initState() {
    widget.controller.addListener(_onIndexChanged);

    super.initState();
  }

  @override
  void didUpdateWidget(NCPageIndicator1 oldWidget) {
    oldWidget.controller.removeListener(_onIndexChanged);
    widget.controller.addListener(_onIndexChanged);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var i = 0; i < widget.count; i++) {
      children.add(AnimatedSize(
        duration: Duration(milliseconds: 400),
        reverseDuration: Duration(milliseconds: 400),
        vsync: this,
        child: Container(
          margin: EdgeInsets.only(left: 4, right: 4),
          width: i == _currentIndex ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
              color: i == _currentIndex ? widget.color : Color(0xffd8d8d8),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)),
        ),
      ));
    }
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _Indicator {
  AnimationController animController;
  Widget view;
}
