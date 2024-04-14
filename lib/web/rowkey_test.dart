import 'package:classdiary2/controller/thisweek_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class RowKeyTest extends StatelessWidget {
  const RowKeyTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode currentFocusNode = FocusNode();
    FocusNode upFocusNode = FocusNode();
    FocusNode middleFocusNode = FocusNode();
    FocusNode downFocusNode = FocusNode();


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container( width: 50,
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                    currentFocusNode.unfocus();
                    middleFocusNode.requestFocus();
                    currentFocusNode = middleFocusNode;
                  }
                },
                child: TextField(
                  focusNode: upFocusNode,
                ),
              ),
            ),

            Container( width: 50,
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                    currentFocusNode.unfocus();
                    downFocusNode.requestFocus();
                    currentFocusNode = downFocusNode;
                  }
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                    currentFocusNode.unfocus();
                    upFocusNode.requestFocus();
                    currentFocusNode = upFocusNode;
                  }
                },
                child: TextField(
                  focusNode: middleFocusNode,
                ),
              ),
            ),

            Container( width: 50,
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                    currentFocusNode.unfocus();
                    middleFocusNode.requestFocus();
                    currentFocusNode = middleFocusNode;
                  }
                },
                child: TextField(
                  focusNode: downFocusNode,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}




