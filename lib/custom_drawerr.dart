import 'package:flutter/material.dart';

//drawer that pulls a full page.
class DrawerStateful extends StatefulWidget {
  final Widget leftDrawer;
  final Widget mainPage;
  final DrawerInfo drawerInfo;

  DrawerStateful({
    Key? key,
    required this.leftDrawer,
    required this.mainPage,
    DrawerInfo? drawerInfo,
  })  : drawerInfo = drawerInfo ?? DrawerInfo(),
        super(key: key);

  @override
  State<DrawerStateful> createState() => _DrawerStatefulState();
}

class _DrawerStatefulState extends State<DrawerStateful>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 246),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    {
      var x =
          MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.height;
      widget.drawerInfo.setStretch(x * 0.75);
      _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    }
    return GestureDetector(
      onHorizontalDragUpdate: _move,
      onHorizontalDragEnd: _settle,
      child: Stack(
        children: [
          backgroundPage(),
          Container(
              width: widget.drawerInfo.getStretch(),
              height: MediaQuery.of(context).size.height,
              color: Colors.blue,
              child: widget.leftDrawer),
          AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: _controller.value * widget.drawerInfo.getStretch(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.green,
                    child: Scaffold(
                      backgroundColor: Colors.green,
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(80),
                        child: Container(
                            color: Colors.green[800],
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 35, 12, 12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        open();
                                      },
                                      icon: const Icon(Icons.menu),
                                      iconSize: 40,
                                    )
                                  ]),
                            )),
                      ),
                      body: widget.mainPage,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  void _move(DragUpdateDetails details) {
    _controller.value += details.delta.dx / widget.drawerInfo.getStretch();
  }

  void _settle(DragEndDetails details) {
    const double kMinFlingVelocity = 365.0;

    //copied from drawer.dart
    if (details.velocity.pixelsPerSecond.dx.abs() >= kMinFlingVelocity) {
      double visualVelocity =
          details.velocity.pixelsPerSecond.dx / widget.drawerInfo.getStretch();

      _controller.fling(velocity: visualVelocity);
    } else if (_controller.value > 0.5) {
      open();
    } else {
      close();
    }
  }

  open() {
    _controller.forward();
  }

  close() {
    _controller.reverse();
  }

  stopAnim() {
    _controller.stop();
  }

  Container backgroundPage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color.fromARGB(255, 41, 1, 12),
    );
  }
}

class DrawerInfo {
  double _stretch = 0;
  var isDrawerOpen = false;

  setStretch(double x) {
    _stretch = x;
  }

  getStretch() {
    return _stretch;
  }
}
