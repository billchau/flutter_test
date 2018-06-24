import 'BaseModel.dart';
import 'dart:ui';
import 'dart:developer';

class ExpenseType extends BaseModel {
  
  ExpenseType(this.id, this.name, this.colorValue){
    setColor(colorValue);
  }

  ExpenseType.fromColor(this.id, this.name, this.color){

  }
  ExpenseType.fromARBG(this.id, this.name, int a, int r, int g, int b) {
    setColorFromARBG(a, r, g, b);
  }

  int id;
  String name;
  int colorValue;
  Color color;

  int getColorString() {
    var colorValue = color.value;
    log('ExpenseType, colorInt: $colorValue');
    return color.value;
  }

  void setColor(int colorValue){
    log('ExpenseType, colorValue: $colorValue');
    color = new Color(colorValue);
  }

  void setColorValue(Color color){
    log('ExpenseType, colorValue: $color');
    colorValue = color.value;
  }

  void setColorFromARBG(int a, int r, int g, int b) {
    log('ExpenseType, colorValue: $a, $r, $g, $b');
    color = new Color.fromARGB(a, r, g, b);
    colorValue = color.value;
  }
}