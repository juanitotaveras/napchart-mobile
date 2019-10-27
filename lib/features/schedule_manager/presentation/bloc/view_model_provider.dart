// Generic Interface for all BLoCs
import 'package:flutter/material.dart';

abstract class ViewModelBase {
  void dispose();
}

// Generic ViewModel provider
class ViewModelProvider<T extends ViewModelBase> extends StatefulWidget {
  ViewModelProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _ViewModelProviderState<T> createState() => _ViewModelProviderState<T>();

  static T of<T extends ViewModelBase>(BuildContext context) {
    final type = _typeOf<ViewModelProvider<T>>();
    ViewModelProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _ViewModelProviderState<T>
    extends State<ViewModelProvider<ViewModelBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
