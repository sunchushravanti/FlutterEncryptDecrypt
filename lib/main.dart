import 'dart:convert';
import 'package:encrypt/encrypt.dart'as encdec;
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/material.dart' ;
import 'package:pointycastle/asymmetric/api.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  {
String username="", designation="";
var encdecData=null;

static final  key = encdec.Key.fromUtf8("My__Encryption__Decryption_Key");
final iv = encdec.IV.fromLength(16);
final encrypter = encdec.Encrypter(encdec.AES(key));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encryption and Decryption"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        TextFormField(
        decoration: InputDecoration(hintText: 'UserName'),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter your UserName';
          }
          return null;
        },
        onChanged: (text) {
          username = text;
        },
      ),

        new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                      encryptData(username);
                  },
                  child: Text('ENCRYPT THE DATA'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    decryptData(username);
                  },
                  child: Text('DECRYPT THE DATA'),
                ),
              ),

            ]
        ),


            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () async {
                        encryptRSAData(username);
                      },
                      child: Text('ENCRYPTION using RSA'),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () async {
                        decryptRSAData(username);
                      },
                      child: Text('DECRYPTION using RSA'),
                    ),
                  ),

                ]
            )
        ]
      )
    ));
  }

//Data Encryption and Decryption using RSA(Asymmetric)
  void encryptRSAData(String text) async{

    final publicKey = await parseKeyFromFile<RSAPublicKey>('test/public.pem');
    final privKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');
    final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));

    final encrypted = encrypter.encrypt(username);
    username=encrypted.toString();
    encdecData=encrypted;
    print("Encrypted RSA value is:${encrypted}");
  }

  void decryptRSAData(String text) async{

    final publicKey = await parseKeyFromFile<RSAPublicKey>('test/public.pem');
    final privKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');
    final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));

    final decrypted = encrypter.decrypt(encdecData);
    print("Decrypted RSA Value is:${decrypted}");
    username=decrypted.toString();
  }

//Data Encryption and Decryption using AES (Symmetric)
void encryptData(String text) {
  final encrypted = encrypter.encrypt(username, iv: iv);
   username=encrypted.toString();
   encdecData=encrypted;
   print("ENcrypted value is:${encrypted.base64}");
  }

void decryptData(String text) {
  final decrypted = encrypter.decrypt(encdecData, iv: iv);
  print("Decrypted Value is:${decrypted}");
  username=decrypted.toString();
}
}
