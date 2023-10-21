import 'package:flutter/material.dart';

//drawer that pulls a full page instead.
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    {
      //the shorted of height/width will be used to calculate stretch.
      var x =
          MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.height;
      widget.drawerInfo.setStretch(x * 0.75);
    }
    return Stack(
      children: [
        backgroundPage(),
        // Page One (drawer)
        Container(
            width: widget.drawerInfo.getStretch(),
            height: MediaQuery.of(context).size.height,
            color: Colors.blue,
            child: widget.leftDrawer),
        Positioned(
          top: 0,
          left: widget.drawerInfo.getLeft(),
          //TODO make drag the width of whole screen
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                print("chaning");
                widget.drawerInfo.setLeft(details.delta.dx);
              });
            },
            onHorizontalDragEnd: (details) {
              print("drag ended");
            },
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
                        padding: const EdgeInsets.fromLTRB(12, 35, 12, 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  openDrawer();
                                },
                                icon: const Icon(Icons.menu),
                                iconSize: 40,
                              )
                            ]),
                      )),
                ),
                body: Center(
                  child: widget.mainPage,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //TODO open drawer slowly instead of instantly.
  openDrawer() {
    setState(() {
      // _controller.forward();

      widget.drawerInfo
          .setLeft(widget.drawerInfo.getStretch() /* * _controller.value */);
    });
  }

// Define a function to open the drawer with a delay
  void openDrawerWithDelay(int numberOfTimes, Duration delay) {
    int count = 0;

    void open() {
      openDrawer(); // Call your openDrawer function here

      if (count < numberOfTimes - 1) {
        Future.delayed(delay, () {
          open();
        });
      }

      count++;
    }

    open();
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
  double _left = 0;
  double _stretch = 0;
  var isDrawerOpen = false;

  setStretch(double x) {
    _stretch = x;
  }

  getStretch() {
    return _stretch;
  }

  setLeft(double x) {
    _left = (_left + x).clamp(0, _stretch);
    print(_left);
  }

  getLeft() {
    return _left;
  }

  //get the difference between _left and _stretch
  getDifference() {
    return _left - _stretch;
  }
}
