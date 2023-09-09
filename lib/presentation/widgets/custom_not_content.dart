import 'package:flutter/material.dart';

class CustomNotContent extends StatelessWidget {
  final String message;
  const CustomNotContent({
    super.key,
    this.message = 'No hay contenido',
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
