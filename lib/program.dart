void main() async {

  // String type = 'audio';    ///text, video, audio
  //
  //
  // if (type == FileType.video.name) {
  //   print("This is a video file");
  // } else if (type == FileType.audio.name){
  //   print('This is a music file');
  // } else if (type == FileType.text.name){
  //   print('This is a string file');
  // } else {
  //   print('This is an unknown type');
  // }

  // switch (type) {
  //   case FileType.video.name:
  //     print("This is a video file");
  //     break;
  //   case FileType.audio.name:
  //     print("This is a music file");
  //     break;
  //   case FileType.text.name:
  //     print("This is a String file");
  //     break;
  //   default:
  //     print("This is an unknown file");
  // }

  var obj = TestClass("Ali", "98w38wybewuybe80woedu");
  obj.logic = '2';
}

class TestClass {
  String name;
  String _secret;// any secret value

  TestClass(this.name, this._secret);

  String get logic => _secret.toUpperCase();

  void set logic (String x) {
    _secret = x;
  }

}

enum FileType {
  text, video, audio
}