import 'package:flutter/material.dart';

///drawer that pulls a full page.
class DrawerStateful extends StatefulWidget {
  //.drawer that comes from the left
  final Widget leftDrawer;

  ///the main page, that can be dragged to the right
  final Widget mainPage;

  ///if null => drawerTheme if null => uses 304.0
  final double? width;

  DrawerStateful(
      {Key? key, required this.leftDrawer, required this.mainPage, this.width})
      : super(key: key);

  @override
  State<DrawerStateful> createState() => _DrawerStatefulState();
}

class _DrawerStatefulState extends State<DrawerStateful>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double width = 0;

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
      //use widget.width if null use drawerTheme.width else use 304.0
      width = widget.width ?? DrawerTheme.of(context).width ?? 304.0;
      //sets up animation from 0.0 to 1.0
      _animation = Tween<double>(begin: 0, end: 1.0).animate(_controller);
    }
    return GestureDetector(
      onHorizontalDragUpdate: _move,
      onHorizontalDragEnd: _settle,
      child: Stack(
        children: [
          //contains left drawer
          Column(
            children: [
              Expanded(
                child: Container(
                  width: width, // Controls the horizontal scaling
                  color: Colors.blue,
                  child: widget.leftDrawer,
                ),
              ),
              // Add other widgets for the main content here
            ],
          ),
          AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                //contains main page.
                return Positioned(
                  top: 0,
                  left: _controller.value * width,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //page should be height of screen.
                    //TODO can I replace this?
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
    _controller.value += details.delta.dx / width;
  }

  //settles the drawer where it belongs, using velocity and location
  void _settle(DragEndDetails details) {
    const double kMinFlingVelocity = 365.0;

    //copied from drawer.dart
    if (details.velocity.pixelsPerSecond.dx.abs() >= kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / width;

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
