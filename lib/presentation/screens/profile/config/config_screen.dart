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
      body: Container(
        padding: EdgeInsets.all(30),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 135,
                      decoration: BoxDecoration(
                          border: Border.all(width: 5, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 5,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/welcome_messages/user.png'))),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                enabled: isEditing,
                decoration: InputDecoration(
                    labelText: "Nombres",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: nombresController.text.toString(),
                    hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        )),
              ),
              SizedBox(height: 10),
              TextField(
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: "Apellidos",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: apellidosController.text.toString(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: correoController.text.toString(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: "Phone",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: telefonoController.text.toString(),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
