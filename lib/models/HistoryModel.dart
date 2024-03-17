class HistoryModel{
  String? expression;
  String? dateTime;
  String? value;

  HistoryModel(this.expression, this.value, this.dateTime);

  HistoryModel.fromMap(value){
    expression = value['expression'];
    dateTime = value['dateTime'];
    this.value = value['value'];
  }

  Map toMap(){
    return {
      'expression' : expression,
      'dateTime' : dateTime,
      'value' : value
    };
  }

  @override
  String toString() {
    return 'HistoryModel{expression: $expression, dateTime: $dateTime, value: $value}';
  }
}