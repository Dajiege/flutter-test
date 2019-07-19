import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:orientation/orientation.dart';

const SourceMap = {
  "稳定线路": "http://jexi.a0296.cn/?url=",
  "稳定线路2":"http://jx.du2.cc/?url=",
  "稳定线路3":"http://jx.drgxj.com/?url=",
  "稳定线路4":"http://jx.618ge.com/?url=",
  "稳定线路5":"http://vip.jlsprh.com/?url=",
  "稳定线路6":"http://jx.598110.com/?url=",
};

class WebviewPage extends StatefulWidget {
  const WebviewPage({Key key, this.url, this.title, this.isVideo = false})
      : super(key: key);
  final String url;
  final String title;
  final bool isVideo;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String _url = '';
  String _title = '';
  String _source = 'http://jexi.a0296.cn/?url=';
  bool _showBar = true;

  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  Future getWebTitle() async {
    String script = 'window.document.title';
    String title = await flutterWebViewPlugin.evalJavascript(script);
    setState(() {
      _title = title.substring(1, title.length - 1);
    });
  }

  List<Widget> getSources() {
    List<Widget> sourceWidget = [];
    SourceMap.forEach((key, value) {
      sourceWidget.add(new ListTile(
        trailing: _source == value ? new Icon(Icons.check) : null,
        title: new Text(key),
        onTap: () {
          setState(() {
            _source = value;
          });
          print('------------切换解析地址：$_source---------------');
          Navigator.pop(context);
        },
      ));
    });
    return sourceWidget;
  }

  void initVideoPage() async {
    OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);
    String script = """
      document.onreadystatechange = function () {
          if (document.readyState === "complete") {
              var aTag = Array.prototype.slice.call(document.getElementsByTagName("a"))
              var imgTag = Array.prototype.slice.call(document.getElementsByTagName("img"))
              var sc = aTag.concat(imgTag)
              for (s of sc){
                  s.remove()
              }
              var creEl = document.createElement
              document.createElement = function(tag){
                if(tag == 'script'){
                  return
                }
                return creEl.call(document,tag)
              }
          }
      }
     """;
    print('-------------删广告开始-------------');
    String ss = await flutterWebViewPlugin.evalJavascript(script);
    print(ss);
    print('-------------删广告结束-------------');
  }

  @override
  void initState() {
    super.initState();
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted && !widget.isVideo) {
        getWebTitle();
        setState(() {
          _url = url;
        });
      }
    });
    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((state) {
      if (mounted) {
        if (state.type == WebViewState.startLoad) {
          print('------------请求地址：${state.url}---------------');
          print('------------解析地址：$_source---------------');
          if (state.url.contains(_source)) {
            print('------------初始化解析页面-------------');
            initVideoPage();
            setState(() {
              _showBar = false;
            });
            print('------------初始化解析页面结束-------------');
          } else if (_showBar == false) {
            OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
            setState(() {
              _showBar = true;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: _showBar
          ? new AppBar(
              title: new Text(_title),
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.menu),
                  onPressed: () {
                    flutterWebViewPlugin.hide();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return new Container(
                            height: 600,
                            child: new ListView(children: getSources()));
                      },
                    ).then((val) {
                      flutterWebViewPlugin.show();
                    });
                  },
                ),
                new IconButton(
                  icon: new Icon(Icons.play_arrow),
                  onPressed: () {
                    flutterWebViewPlugin.reloadUrl('$_source$_url');
                  },
                )
              ],
            )
          : null,
      bottomNavigationBar: _showBar
          ? new Container(
              height: 60.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      flutterWebViewPlugin.goBack();
                    },
                  ),
                  new IconButton(
                    icon: new Icon(Icons.refresh),
                    onPressed: () {
                      flutterWebViewPlugin.reload();
                    },
                  ),
                  new IconButton(
                      icon: new Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        flutterWebViewPlugin.goForward();
                      }),
                ],
              ))
          : null,
      url: widget.url,
      userAgent:
          'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1',
      initialChild: new Container(
        decoration: new BoxDecoration(color: Colors.black),
      ),
    );
  }
}
