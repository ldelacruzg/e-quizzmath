import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/infrastructure/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
// Controladores de edición para los campos
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  // Bandera para habilitar o deshabilitar la edición
  bool isEditing = false;
  // Función para alternar entre edición y visualización
  void toggleEdit() {
    setState(() {
      if (isEditing) {
        saveChanges();

      }
      isEditing = !isEditing;
    });
  }

  @override
  void initState() {
    super.initState();
    // Cargar la información del usuario al iniciar la pantalla
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('login_id') ?? '';
    DocumentSnapshot documentSnapshot;
    documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get()
        .then((value) => documentSnapshot = value);
    if (documentSnapshot != null && documentSnapshot.exists) {
      setState(() {
        nombresController.text = documentSnapshot['FullName'];
        apellidosController.text = documentSnapshot['LastName'];
        correoController.text = documentSnapshot['email'];
        telefonoController.text = documentSnapshot['phone'];
      });
    } else {
      // El documento no existe en Firestore, maneja este caso según tus necesidades
    }
  }
  Future<void>  saveChanges() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('login_id') ?? '';
    try{

      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'FullName': nombresController.text.toString(),
        'LastName': apellidosController.text.toString(),
        'email': correoController.text.toString(),
        'phone': telefonoController.text.toString(),
      });

      Fluttertoast.showToast(msg: apellidosController.text.toString() +nombresController.text.toString());
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion personal'),
      ),
      body:Container(
        child:  ListView(
         children: [
           Center(
             child: Stack(
               children: [
                  Row(
                   children: [
                     Icon(Icons.person,color: Colors.amber,size: 20,),
                     Text('Configuracion',),
                     IconButton(onPressed: (){}, icon:Icon(Icons.navigate_next))
                   ],
                 )
               ],
             ),
           )
         ],
        ),
      ),
    );
  }
}
