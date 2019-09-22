import 'package:flutter/material.dart';

abstract class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return (isPortrait) ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext context);

  Widget buildLandscape(BuildContext context);
}
