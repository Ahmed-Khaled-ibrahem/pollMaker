import 'package:flutter/material.dart';
import 'constants.dart';

class defualtPageDesign extends StatefulWidget {
  const defualtPageDesign(
      {required Widget this.child,
      required String this.title,
        FloatingActionButton? this.actionButton,
        Widget? this.navigation,
        List<Widget>? this.actions,
      Key? key})
      : super(key: key);

  final Widget child;
  final String title;
  final FloatingActionButton? actionButton;
  final List<Widget>? actions;
  final Widget? navigation;

  @override
  _defualtPageDesignState createState() => _defualtPageDesignState();
}

class _defualtPageDesignState extends State<defualtPageDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      bottomNavigationBar: widget.navigation,
      floatingActionButton: widget.actionButton,
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: black,
          elevation: 0,
          centerTitle: false,
          actions: widget.actions),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: black,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: whiteshade,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45))),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

