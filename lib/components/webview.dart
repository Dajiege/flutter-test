import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({Key key, this.url, this.title}) : super(key: key);
  final String url;
  final String title;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String _url = '';
  String _title = '';
  String _src = '';

  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  Future getWebTitle() async {
    String script = 'window.document.title';
    String title = await flutterWebViewPlugin.evalJavascript(script);
    setState(() {
      _title = title.substring(1, title.length - 1);
    });
  }

  Future initVideo() {
    String initjs = """
        var createElement = document.createElement;
        document.createElement = function (tag) {
            switch (tag) {
                case 'a':
                    break;
                case 'img':
                    break;
                default:
                    return createElement.apply(this, arguments);
            }
        }
    """;
    print('---------------阻止新增标签');
    flutterWebViewPlugin.evalJavascript(initjs);
  }

  Future getSrc() {
    String script = """
      document.getElementById('video').webkitEnterFullscreen()
      document.getElementById('video').src
    """;
    new Timer(new Duration(seconds: 20), () async {
      String src = await flutterWebViewPlugin.evalJavascript(script);
      setState(() {
        _src = src;
      });
      print('-------------播放路径：$_src');
    });
  }

  @override
  void initState() {
    super.initState();
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        getWebTitle();
        if (!url.contains('jexi.a0296.cn/?url=')) {
          setState(() {
            _url = url;
          });
        }
      }
    });
    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        print('------------状态开始------------');
        print(state.type);
        print(state.url);
        print('------------状态结束------------');
        if (state.url.contains('jexi.a0296.cn/?url=') &&
            state.type == WebViewState.startLoad) {
          initVideo();
        }
        if (state.url.contains('jexi.a0296.cn/?url=') &&
            state.type == WebViewState.finishLoad) {
          getSrc();
        }
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: new AppBar(
        title: new Text(_title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.play_arrow),
            onPressed: () {
              flutterWebViewPlugin.reloadUrl('http://jexi.a0296.cn/?url=$_url');
            },
          )
        ],
      ),
      bottomNavigationBar: new Container(
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
          )),
      url: widget.url,
    );
  }
}
