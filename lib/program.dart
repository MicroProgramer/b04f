void main() async {
  // var x = await sumNums(10, 20);
  // print(x);


  print('before loop');

  int i = 0;
  Future.doWhile(() async {
    print(i);
    // await Future.delayed(Duration(milliseconds: 500));
    i++;
    return (i < 3);
  });

  print('after loop');

}

Future<int> sumNums(int a, int b) async {
  await Future.delayed(Duration(seconds: 1));
  await Future.delayed(Duration(seconds: 1));
  return a + b;
}
