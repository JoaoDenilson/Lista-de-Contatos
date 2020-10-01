import 'dart:io';

import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  ContactHelper helper = ContactHelper();
  List<Contact> _contacts = List(); 
  
  void _getAllContacts(){
    helper.getAllContact().then((list) {
      setState(() {
        _contacts = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }


  Widget _contactCard(BuildContext context, int index){
    var contact = _contacts[index];

    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: contact.img != null ?
                      FileImage(File(contact.img)) :
                      AssetImage("images/person.png"),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact.name ?? "", style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(contact.email ?? "", style: TextStyle(fontSize: 18.0)),
                      Text(contact.phone ?? "", style: TextStyle(fontSize: 18.0))
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
      onTap: (){
        _showOptions(context, contact);
      },
    );
  }


  void _showOptions(BuildContext context, Contact contact){
    showModalBottomSheet(context: context, builder: (context){
      return BottomSheet( 
        builder: (context){
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlatButton(
                  child: Text("Ligar",style: TextStyle(color: Colors.red, fontSize: 20.0),),
                  onPressed: (){
                    launch("tel:${contact.phone}");
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Editar",style: TextStyle(color: Colors.red, fontSize: 20.0),),
                  onPressed: (){
                    Navigator.pop(context);
                   _showContactPage(contact: contact);
                  },
                ),
                FlatButton(
                  child: Text("Remover",style: TextStyle(color: Colors.red, fontSize: 20.0),),
                  onPressed: (){
                   helper.deleteContact(contact.id).then((value){
                     Navigator.pop(context);
                     _getAllContacts();
                   });
                  },
                )
              ],
            ),
          );
        },
        onClosing: (){},
      );
    });
  }

  
  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(contact);
      }
      else{
        await helper.saveContact(contact);
      }
      _getAllContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: (){
          _showContactPage();
        },
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: _contacts.length,
        itemBuilder: (context,index){
          return _contactCard(context,index);
        },
      ),
    );
  }
}