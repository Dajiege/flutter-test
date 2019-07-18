import 'package:flutter/material.dart';
import '../components/webview.dart';

TextStyle bold24Roboto = new TextStyle(
  color: Colors.white,
  fontSize: 24.0,
  fontWeight: FontWeight.w900,
);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('首页'),
        ),
        body: new Container(
          child: new Wrap(
              spacing: 10, //主轴上子控件的间距
              runSpacing: 10, //交叉轴上子控件之间的间距
              children: <Widget>[
                new MyButton('腾讯视频', to: 'https://m.v.qq.com'),
                new MyButton('爱奇艺', to: 'https://m.iqiyi.com'),
                new MyButton('芒果TV', to: 'https://m.mgtv.com'),
                new MyButton('乐视TV', to: 'http://m.le.com/'),
              ]),
          padding: new EdgeInsets.all(15.0),
        ));
  }
}

class MyButton extends StatelessWidget {
  MyButton(
    this.data, {
    Key key,
    this.onPress,
    this.to,
  }) : super(key: key);
  final String data;
  final String to;
  final Function onPress;

  final _buttonStyle = const TextStyle(color: Color.fromRGBO(255, 255, 255, 1));

  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          if (onPress is Function) {
            onPress();
          }
          if (to is String) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new WebviewPage(url:to, title: data)));
          }
        },
        child: new Container(
          decoration: new BoxDecoration(
              color: Colors.lightBlue[200],
              borderRadius: const BorderRadius.all(const Radius.circular(4.0))),
          width: 80.0,
          height: 80.0,
          child: new Center(child: new Text(data, style: _buttonStyle)),
        ));
  }
}
