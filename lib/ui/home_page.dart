import 'package:flutter/material.dart';
import 'package:agenda_contatos/helpers/contact_helper.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();

    //Contact c = Contact();
    //c.name = "Joao";
    //c.email = "email@email.com";
    //c.phone = "88-990001122";
    //c.img = "Teste";

    //helper.saveContact(c).then((contact){
      //print(contact);
    //});

    helper.getAllContact().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}