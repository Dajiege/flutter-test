import 'package:flutter/material.dart';
import '../components/webview.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String txlogo = 'assets/txlogo.png';
    String iqiyi = 'assets/iqiyilogo.png';
    String mglogo = 'assets/mglogo.png';
    String lelogo = 'assets/lelogo.png';

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('首页'),
        ),
        body: new Container(
          child: new Wrap(
              spacing: 10, //主轴上子控件的间距
              runSpacing: 10, //交叉轴上子控件之间的间距
              children: <Widget>[
                new MyButton('腾讯视频', to: 'https://m.v.qq.com', logo: txlogo),
                new MyButton('爱奇艺', to: 'https://m.iqiyi.com', logo: iqiyi),
                new MyButton('芒果TV', to: 'https://m.mgtv.com', logo: mglogo),
                new MyButton('乐视TV', to: 'http://m.le.com/',logo: lelogo),
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
    this.logo,
  }) : super(key: key);
  final String data;
  final String to;
  final String logo;
  final Function onPress;

  final _buttonStyle = const TextStyle(
    fontSize: 14.0,
  );

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
        child: new Column(
          children: <Widget>[
            new Container(
          decoration: new BoxDecoration(
              color: logo is String ? null: Colors.lightBlue[700],
              borderRadius: const BorderRadius.all(const Radius.circular(4.0))),
          width: 80.0,
          height: 80.0,
          margin: new EdgeInsets.only(bottom: 3.0),
          child: new Center(
            child: logo is String ? new Image.asset(logo,width: 60.0,) : new Text(data)
          ),
        ),
        new Text(data, style: _buttonStyle)
          ],
        ) );
  }
}
