import 'dart:async';
import 'user.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';


class PaymentScreen1 extends StatefulWidget {

  final User user;
  final String orderid,val;

  PaymentScreen1({this.user,this.orderid,this.val});

  @override
  _PaymentScreen1State createState() => _PaymentScreen1State();
}

class _PaymentScreen1State extends State<PaymentScreen1> {

  Completer<WebViewController>_controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
            child: Scaffold(
              appBar: AppBar(
                title: Text('PAYMENT'),
                backgroundColor: Colors.tealAccent[700],
                centerTitle: true,
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: WebView(
                      initialUrl: 'http://lawlietaini.com/myrecycle_user/php/payment.php?email='+
                      widget.user.email+
                      '&mobile='+
                      widget.user.phone+
                      '&name='+
                      widget.user.name+
                      '&amount='
                      +widget.val+
                      '&orderid='+
                      widget.orderid,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController){
                        _controller.complete(webViewController);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }
      
        Future<bool> _onBackPressAppBar() async{

          print('onbackpress payment');
          String urlgetuser = "http://lawlietaini.com/myrecycle_user/php/get_user.php";

          http.post(urlgetuser,body:{
            "email" :widget.user.email,
          }).then((res){
            print(res.statusCode);
            var string = res.body;
            List dres = string.split(",");
            print(dres);
            if(dres[0]=='success'){

              User updateuser = new User(
                name: dres[1],
                email: dres[2],
                phone: dres[3],
                points: dres[4],
                credit: dres[5],
                rating: dres[6],
              );
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(user: updateuser,)));
            }
          }).catchError((err){
            print(err);
          });
          return Future.value(false);
  }
}