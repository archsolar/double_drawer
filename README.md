# custom_drawer

A simple alternative to drawer, that let's you grab a whole customizable page! 
https://github.com/archsolar/custom_drawer/assets/46627284/61ff7485-0bb2-41e0-8b65-bfefd3261141

## Getting Started
simply put your widgets where you want them:
```dart
  Widget build(BuildContext context) {
    return DrawerStateful(
      leftDrawer: yourLeftDrawer(),
      mainPage: yourMainPage(),
      drawerInfo: DrawerInfo(),
    );
```
