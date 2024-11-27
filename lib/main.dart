import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cepController = TextEditingController();
  String _result = '';
  bool _isButtonPressed = false;

  Future<void> _searchCEP() async {
    if (_cepController.text.length != 8) {
      setState(() {
        _result = 'CEP inválido';
      });
      return;
    }

    final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/${_cepController.text}/json/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _result = 'CEP: ${data['cep']}\n'
            'Logradouro: ${data['logradouro']}\n'
            'Complemento: ${data['complemento']}\n'
            'Bairro: ${data['bairro']}\n'
            'Localidade: ${data['localidade']}\n'
            'UF: ${data['uf']}';
      });
    } else {
      setState(() {
        _result = 'CEP não encontrado';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP - Michael - 02-11-2024'),
      ),
      backgroundColor: Colors.lightBlue[100], 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              decoration: const InputDecoration(labelText: 'CEP'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isButtonPressed = true; // Altera o estado do botão para pressionado
                });
                _searchCEP();
                Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    _isButtonPressed = false; // Volta a cor do botão ao normal após 1 segundo
                  });
                });
              },
              style: ElevatedButton.styleFrom(
                primary: _isButtonPressed ? Colors.black : Colors.blue, // Cor do botão
              ),
              child: const Text('Consultar'),
            ),
            const SizedBox(height: 16),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
