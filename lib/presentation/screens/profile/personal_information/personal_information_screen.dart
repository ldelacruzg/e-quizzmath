import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});
  @override
  State<StatefulWidget> createState()=>_PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen>{
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
    if (documentSnapshot.exists) {
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Información personal'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icono de flecha hacia atrás
          onPressed: () {
            // Acción a realizar cuando se presiona la flecha hacia atrás
            // Puedes añadir tu lógica aquí, como la navegación hacia atrás.
            Navigator.pop(context); // Ejemplo de navegación hacia atrás
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      // Establece la decoración del contenedor
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        border: Border.all(
                          color: Colors.black12,
                          width: 5,
                        ),
                      ),
                      // Define el ancho del contenedor como el 35% del ancho de la pantalla
                      width: size.width * 0.35,
                      // Define la altura del contenedor como el 35% del ancho de la pantalla
                      height: size.width * 0.35,
                      // El contenido del contenedor es un widget personalizado llamado RandomAvatar
                      child: RandomAvatar("${nombresController.text} ${apellidosController.text}"), // Pasa el nombre como parámetro
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                enabled: isEditing,
                decoration:  InputDecoration(
                    fillColor: const Color.fromRGBO(247, 238, 249, 2),
                    filled: true,
                    labelText: "NOMBRES",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.person, size: 20),
                    hintText: nombresController.text.toString(),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 10),
              TextFormField(
                enabled: isEditing,
                decoration: InputDecoration(
                  fillColor: const Color.fromRGBO(247, 238, 249, 2),
                  filled: true,
                  labelText: "APELLIDOS",
                  prefixIcon: const Icon(Icons.person),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: apellidosController.text.toString(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                enabled: isEditing,
                decoration: InputDecoration(
                  fillColor: const Color.fromRGBO(247, 238, 249, 2),
                  filled: true,
                  labelText: "EMAIL",
                  prefixIcon: const Icon(Icons.email, size: 20),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: correoController.text.toString(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                enabled: isEditing,
                decoration: InputDecoration(
                  fillColor: const Color.fromRGBO(247, 238, 249, 2),
                  filled: true,
                  labelText: "CELULAR",
                  prefixIcon:const Icon(Icons.phone, size: 20),
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
