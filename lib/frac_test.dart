import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';

extension UtilExtensions on String {
  List<String> multiSplit(Iterable<String> delimeters) => delimeters.isEmpty
      ? [this]
      : this.split(RegExp(delimeters.map(RegExp.escape).join('|')));
}

class FracTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var frac0 = '';
    var frac1 = '';
    var frac2 = '';
    var frac3 = '';
    var slash = '';
    var frac_str = '';

    return Center(
      child: Container(
        width: 500,
        height: 500,
        constraints: BoxConstraints(maxWidth: 800),
        child: ChangeNotifierProvider(
          create: (context) => TextEditingController(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Consumer<TextEditingController>(
                  builder: (context, controller, _) => TextField(
                    onChanged: (value) {
                      frac_str = '';
                      var str = value;
                      // var str = '1/2';
                      var fracList = str.multiSplit(['+', '-', '*', '<', '>']);
                      fracList.remove('');
                      var splitList = [str.indexOf('+'), str.indexOf('-'), str.indexOf('*'), str.indexOf('÷')];
                      var oneList = str.split('');
                      // splitList.sort((a, b) => a.compareTo(b));

                      var operList = [];
                      var operList2 = [];
                      var one_index = 0;
                      for(var one in oneList) {
                        if (one == '+' || one == '-' || one == '*' || one == '>' || one == '<') {
                          operList.add(one_index.toString()+one);
                          operList2.add(one_index);
                        }
                        one_index ++;
                      }

                      var operList3 = [];
                      var one_index2 = 0;
                      var frac_before = '';
                      var frac_after = '';

                      for(var one in operList2) {
                        if (one_index2 == 0) {
                          frac_before = str.substring(0,operList2[one_index2]); // 1/2
                        }else {
                          frac_before = str.substring(operList2[one_index2-1]+1,operList2[one_index2]); // 1/2
                        }
                        // 분수인지 자연수인지
                        if (frac_before.contains('/') == true) {
                          frac_after = r'\frac{' + frac_before.split('/')[0] + '}{' + frac_before.split('/')[1] + '}';
                        }else {
                          frac_after = frac_before;
                        }

                        frac_str = frac_str + frac_after + operList[one_index2].substring(operList[one_index2].length-1,operList[one_index2].length);


                        // if (one != 0) {
                        //   // operList3.add(str.substring(operList2[one_index2 - 1]+1,operList2[one_index2]));
                        //   frac_before = str.substring(operList2[one_index2 - 1]+1,operList2[one_index2]); // 1/2
                        //   frac_after = r'\frac{' + frac_before.split('/')[0] + '}{' + frac_before.split('/')[1] + '}';
                        //   operList3.add(frac_after);
                        //   operList3.add(operList[one_index2]);
                        //   frac_str = frac_str + frac_after + operList[one_index2].substring(operList[one_index2].length-1,operList[one_index2].length);
                        // }
                        one_index2 ++;
                      }
                      // operList3.add(fracList[fracList.length-1]);
                      frac_before = fracList[fracList.length-1]; // 1/2
                      frac_after = r'\frac{' + frac_before.split('/')[0] + '}{' + frac_before.split('/')[1] + '}';
                      frac_str = frac_str + frac_after;

                      print(oneList);
                      print(fracList);
                      print(operList);
                      print(operList2);
                      print(operList3);
                      print(frac_str);
                      // print('1/2'.substring(0, '1/2'.indexOf('/')));
                      // print('1/2'.substring('1/2'.indexOf('/')+1, '1/2'.length));

                      // print(str.indexOf('m'));
                      // print(str.substring(str.indexOf('+'), str.indexOf('+')+1));
                      //
                      // print(str.substring(0, str.indexOf('/')));
                      // print(str.substring(str.indexOf('/')+1, str.length));
                      // print(value.split('/'));
                      // prefix = r'\frac{1}{4}';
                      frac0 = r'\frac{';
                      frac1 = '1';
                      frac2 = '100';
                      // ddd = r'\frac{1}{2}';
                      frac3 = frac0 + frac1 + '}{' + frac2 + '}';

                    },
                    controller: controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Input TeX equation here1',
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Flutter Math's output",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.all(10),
                          child: Consumer<TextEditingController>(
                            builder: (context, controller, _) =>
                                SelectableMath.tex(
                                  frac_str,
                                  // controller.value.text,
                                  textStyle: TextStyle(fontSize: 22),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}