import 'package:flutter/material.dart';

///
///Author: YoungChan
///Date: 2019/8/27 17:13
///Description: PageView 指示器
///

class NCPageIndicator2 extends StatefulWidget {
  final int count;
  final PageController controller;
  final EdgeInsets padding;
  final Color color;
  NCPageIndicator2({
    Key key,
    this.count = 0,
    this.color = Colors.blue,
    @required this.controller,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 24),
  })  : assert(controller != null),
        super(key: key);

  @override
  _NCPageIndicator2State createState() {
    return _NCPageIndicator2State();
  }
}

class _NCPageIndicator2State extends State<NCPageIndicator2>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  List<_Indicator> _indicators = [];

  void _onIndexChanged() {
    var page = widget.controller.page.round();

    if (page != _currentIndex) {
      _indicators[_currentIndex].animController.reverse();
      _currentIndex = page;
      _indicators[_currentIndex].animController.forward();
    }
  }

  void _initIndicators() {
    for (var i = 0; i < widget.count; i++) {
      var indicator = _Indicator()
        ..animController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 300),
            lowerBound: 0.5);
      indicator.view = ScaleTransition(
        scale: CurvedAnimation(
            parent: indicator.animController, curve: Curves.easeOut),
        child: Container(
          margin: EdgeInsets.only(left: 4, right: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            shape: BoxShape.circle,
          ),
        ),
      );
      if (i == _currentIndex) {
        indicator.animController.forward();
      } else {
        indicator.animController.reverse();
      }
      _indicators.add(indicator);
    }
  }

  @override
  void initState() {
    widget.controller.addListener(_onIndexChanged);
    _initIndicators();
    super.initState();
  }

  @override
  void didUpdateWidget(NCPageIndicator2 oldWidget) {
    oldWidget.controller.removeListener(_onIndexChanged);
    widget.controller.addListener(_onIndexChanged);
    _indicators.forEach((v) {
      v.animController.dispose();
    });
    _indicators.clear();
    _initIndicators();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onIndexChanged);
    _indicators.forEach((v) {
      v.animController.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children = _indicators.map((v) => v.view).toList();

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
