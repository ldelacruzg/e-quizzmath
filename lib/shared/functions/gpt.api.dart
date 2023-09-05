import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestMessageGPT {
  final String role;
  final String content;

  RequestMessageGPT({
    this.role = 'user',
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class RequestGPT {
  final String model;
  final List<RequestMessageGPT> messages;
  final double temperature;

  RequestGPT({
    this.model = 'gpt-3.5-turbo',
    required this.messages,
    this.temperature = 0.7,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': messages.map((e) => e.toJson()).toList(),
      'temperature': temperature,
    };
  }
}

String buildContentMessage() {
  return 'generar en un arreglo de objetos, en formato json, 5 preguntas sobre vectores de álgebra lineal, enfocado en operaciones con vectores, y que cada objeto contengan las siguientes propiedades: question, options, correctAnswer y difficulty. Tener en cuenta que correctAnswer es la posición de options de la respuesta correcta y difficulty solo puede ser easy, medium y hard.';
}

Future<String> getResponseGPT() async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer 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'
  };

  final body = jsonEncode(
    RequestGPT(
      messages: [
        RequestMessageGPT(content: buildContentMessage()),
      ],
    ),
  );

  final response = await http.post(
    url,
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final responseContent = data['choices'][0]['message']['content'];

    return responseContent;
  } else {
    throw Exception('Error al obtener la respuesta de GPT');
  }
}

List<dynamic> extractJsonFromResponseGPT(String response) {
  // Buscar la parte del texto que contiene el arreglo JSON
  RegExp exp = RegExp(r'```json([\s\S]+?)```');
  RegExpMatch? match = exp.firstMatch(response);

  if (match != null) {
    return json.decode(match.group(1) ?? match.group(2)!);
  }

  return json.decode(response);
}
