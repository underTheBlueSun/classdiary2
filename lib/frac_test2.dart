import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

extension UtilExtensions on String {
  List<String> multiSplit(Iterable<String> delimeters) => delimeters.isEmpty
      ? [this]
      : this.split(RegExp(delimeters.map(RegExp.escape).join('|')));
}

class FracTest2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var frac0 = '';
    var frac1 = '';
    var frac2 = '';
    var frac3 = '';
    var slash = '';
    var frac_str = '';

    // var aaa = r'$$x = {3b \over 22}$$';
    var aaa = '다음중 맞는 것은? 다음중 맞는 것은? 다음중 맞는 것은? \n  1 + {3b / 2a} + {200/3000} - 3';
    // var aaa = '다음중 맞는 것은? 다음중 맞는 것은? 다음중 맞는 것은? \n  x= {3b / 2a} + 1';
    var bbb = r'' + aaa.replaceAll('{', r'\({').replaceAll('}', r'}\)').replaceAll('/', r'\over');
    var ccc = r'' + aaa.replaceAll('/', r'\over').replaceAll('\n', r'$$') + r'$$';
    // var ccc = r'' + aaa.replaceAll('{', r'$${').replaceAll('/', r'\over').replaceAll('\n', r'$$') + r'$$';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.delete_forever), color: Colors.black, iconSize: 40,
          onPressed: () {
            QuizController.to.is_visible_count_down.value = true;

          },
        ),
        Obx(() => Visibility(
            visible: QuizController.to.is_visible_count_down.value,
            child: Countdown(
              seconds: 5,
              build: (BuildContext context, double time) {
                if (time.toString() == '5') {
                  return buildStack('5');
                }else if (time.toString() == '4') {
                  return buildStack('4');
                }else if (time.toString() == '3') {
                  return buildStack('3');
                }else if (time.toString() == '2') {
                  return buildStack('2');
                }else if (time.toString() == '1') {
                  return buildStack('1');
                }else  {
                  return buildStack('0');
                }
              },
              interval: Duration(milliseconds: 1000),
              onFinished: () {
                QuizController.to.is_visible_count_down.value = false;
              },
            ),
          ),
        ),
      ],
    );


    // return SingleChildScrollView(
    //   child: Container(
    //     width: 300,
    //     child: TeXView(
    //       child: TeXViewColumn(children: [
    //         TeXViewInkWell(
    //           id: "id_0",
    //           child: TeXViewColumn(children: [
    //             TeXViewDocument(r"""<h2>Flutter \( \rm\\TeX \)</h2>""",
    //                 style: TeXViewStyle(textAlign: TeXViewTextAlign.center)),
    //             TeXViewContainer(
    //               child: TeXViewImage.network(
    //                   'https://raw.githubusercontent.com/shah-xad/flutter_tex/master/example/assets/flutter_tex_banner.png'),
    //               style: TeXViewStyle(
    //                 margin: TeXViewMargin.all(10),
    //                 borderRadius: TeXViewBorderRadius.all(20),
    //               ),
    //             ),
    //             // TeXViewDocument(r"""<p>
    //             //            When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are
    //             //            $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$
    //             //            $$x = {3b \over 2a}.$$</p>""",
    //             //     style: TeXViewStyle.fromCSS(
    //             //         'padding: 15px; color: white; background: green'))
    //             TeXViewDocument(bbb,
    //             // TeXViewDocument(r'$$x = {3b \over 2a}$$',
    //                 style: TeXViewStyle.fromCSS(
    //                     'padding: 15px; color: white; background: green')),
    //             TeXViewDocument(ccc,
    //                 // TeXViewDocument(r'$$x = {3b \over 2a}$$',
    //                 style: TeXViewStyle.fromCSS(
    //                     'padding: 15px; color: white; background: green')),
    //           ]),
    //         )
    //       ]),
    //       style: TeXViewStyle(
    //         elevation: 10,
    //         borderRadius: TeXViewBorderRadius.all(25),
    //         border: TeXViewBorder.all(TeXViewBorderDecoration(
    //             borderColor: Colors.blue,
    //             borderStyle: TeXViewBorderStyle.solid,
    //             borderWidth: 5)),
    //         backgroundColor: Colors.white,
    //       ),
    //     ),
    //   ),
    // );

    // return Center(
    //   child: Container(
    //     width: 500,
    //     height: 500,
    //     constraints: BoxConstraints(maxWidth: 800),
    //     child: ChangeNotifierProvider(
    //       create: (context) => TextEditingController(),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.max,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.all(10),
    //             child: Consumer<TextEditingController>(
    //               builder: (context, controller, _) => TextField(
    //                 onChanged: (value) {
    //                   var aaa = '{ (2a) (3b) }';
    //                   // var replace1 = value.replaceAll('{', r'\frac ');
    //                   // var replace2 = replace1.replaceAll('}', '');
    //                   frac_str = r'' + value.replaceAll('{', r'\frac ').replaceAll('}', '').replaceAll('*', r'\times').replaceAll('/', r'\div').replaceAll('[]', r'\Box')
    //                       .replaceAll('(', '{').replaceAll(')', '}');
    //                   print(frac_str);
    //                   // if (value.contains('{')) {
    //                   //   var after_value1 = value.substring(0, value.indexOf('{'));
    //                   //   var after_value2 = value.substring(value.indexOf('{')+1, value.indexOf('}'));
    //                   //   var after_value3 = value.substring(value.indexOf('}')+1, value.indexOf('{'));
    //                   //   var after_value4 = value.substring(value.indexOf('{')+1, value.indexOf('}'));
    //                   //   frac_str = r'' +  after_value1 + r'\frac' +  after_value2 + r'' +  after_value3 + r'\frac' +  after_value4;
    //                   // }else {
    //                   //   var after_value = value;
    //                   //   frac_str = r'' +  after_value;
    //                   // }
    //
    //                   // var ccc = '1';
    //                   // frac_str = r''+ccc + r'\frac 2 3'; // 대분수
    //                   // frac_str = r''+ccc + r'+' + r'\frac 2 3'; // 1 + 2/3
    //                   // frac_str = r'1 + \frac 2 3';
    //                   // frac_str = r'1 + \frac 2 3';
    //                   // r'x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}'
    //
    //
    //                   // frac_str = value;
    //
    //                 },
    //                 controller: controller,
    //                 keyboardType: TextInputType.multiline,
    //                 maxLines: null,
    //                 decoration: InputDecoration(
    //                   border: OutlineInputBorder(),
    //                   labelText: 'Input TeX equation here1',
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Expanded(
    //             flex: 1,
    //             child: Padding(
    //               padding: const EdgeInsets.all(10.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.stretch,
    //                 children: [
    //                   Center(
    //                     child: Text(
    //                       "Flutter Math's output",
    //                       style: Theme.of(context).textTheme.titleLarge,
    //                     ),
    //                   ),
    //                   Expanded(
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                         border: Border.all(width: 1),
    //                         borderRadius: BorderRadius.circular(5.0),
    //                       ),
    //                       alignment: Alignment.topCenter,
    //                       padding: EdgeInsets.all(10),
    //                       child: Consumer<TextEditingController>(
    //                         builder: (context, controller, _) =>
    //                             SelectableMath.tex(
    //                               frac_str,
    //                               // controller.value.text,
    //                               textStyle: TextStyle(fontSize: 30),
    //                             ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

  }

  Stack buildStack(time) {
    return Stack(
          children: <Widget>[
            Text(time, maxLines: 2, style: TextStyle(fontSize: 100, fontFamily: 'Jua',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.black.withOpacity(0.6),
            ),
            ),
            Text(time, maxLines: 2, style: TextStyle(fontSize: 100, fontFamily: 'Jua', color: Colors.yellow,),),
          ],
        );
  }

}