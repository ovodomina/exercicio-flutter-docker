import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: CalculadoraIMC(),
      debugShowCheckedModeBanner: false,
    ));

class CalculadoraIMC extends StatefulWidget {
  const CalculadoraIMC({super.key});

  @override
  State<CalculadoraIMC> createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _resultado = "Informe seus dados";

  void _calcular() {
    double? weight = double.tryParse(_weightController.text);
    double? height = double.tryParse(_heightController.text);

    if (weight == null || height == null || height == 0) {
      setState(() => _resultado = "Dados inválidos");
      return;
    }

    double imc = weight / ((height / 100) * (height / 100));
    setState(() {
      if (imc < 18.5) _resultado = "Abaixo do peso (${imc.toStringAsFixed(1)})";
      else if (imc < 25) _resultado = "Peso ideal (${imc.toStringAsFixed(1)})";
      else _resultado = "Acima do peso (${imc.toStringAsFixed(1)})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IMC Fatec"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _weightController, decoration: const InputDecoration(labelText: "Peso (kg)")),
            TextField(controller: _heightController, decoration: const InputDecoration(labelText: "Altura (cm)")),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _calcular, child: const Text("Calcular")),
            const SizedBox(height: 30),
            Text(_resultado, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}