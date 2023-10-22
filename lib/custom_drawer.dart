import 'package:flutter/material.dart';

///drawer that pulls a full page.
class DrawerStateful extends StatefulWidget {
  //drawer that comes from the left
  final Widget leftDrawer;
  //the main page, that can be dragged to the right
  final Widget mainPage;
  //holds data related to the drawer
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
      //grabs 75% of the screen width. ALWAYS grabs WIDTH of physical form,
      //regardless if phone is in portrait or landscape.
      var x =
          MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.height;
      widget.drawerInfo.setStretch(x * 0.75);
      //sets up animation from 0.0 to 1.0
      _animation = Tween<double>(begin: 0, end: 1.0).animate(_controller);
    }
    return GestureDetector(
      onHorizontalDragUpdate: _move,
      onHorizontalDragEnd: _settle,
      child: Stack(
        children: [
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
                                      onPressed: open,
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

  //finger drag proportional to the getStretch
  void _move(DragUpdateDetails details) {
    _controller.value += details.delta.dx / widget.drawerInfo.getStretch();
  }

  //settles the drawer where it belongs, using velocity and location
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

  //open drawer
  open() {
    _controller.forward();
  }

  //close drawer
  close() {
    _controller.reverse();
  }

  Container backgroundPage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color.fromARGB(255, 41, 1, 12),
    );
  }
}

///holds drawer info
class DrawerInfo {
  double _stretch = 0;
  // var isDrawerOpen = false;

  setStretch(double x) {
    _stretch = x;
  }

  getStretch() {
    return _stretch;
  }
}
