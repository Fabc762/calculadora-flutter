// lib/main.dart

import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraNavidadApp());
}

class CalculadoraNavidadApp extends StatelessWidget {
  const CalculadoraNavidadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Navideña',
      theme: ThemeData(
        // Colores base para el tema navideño
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900).copyWith(
          primary: Colors.red.shade700, // Rojo principal
          secondary: Colors.green.shade700, // Verde para operadores
          background: Colors.grey.shade100,
        ),
        useMaterial3: true,
      ),
      home: const CalculadoraNavidadHome(),
    );
  }
}

class CalculadoraNavidadHome extends StatefulWidget {
  const CalculadoraNavidadHome({super.key});

  @override
  State<CalculadoraNavidadHome> createState() => _CalculadoraNavidadHomeState();
}

class _CalculadoraNavidadHomeState extends State<CalculadoraNavidadHome> {
  String output = "0";
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";

  // Lógica de cálculo principal
  void buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      _output = "0";
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
      num1 = double.parse(output);
      operand = buttonText;
      _output = "0";
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        return;
      }
      _output = _output + buttonText;
    } else if (buttonText == "=") {
      num2 = double.parse(output);

      if (operand == "+") {
        _output = (num1 + num2).toString();
      }
      if (operand == "-") {
        _output = (num1 - num2).toString();
      }
      if (operand == "×") {
        _output = (num1 * num2).toString();
      }
      if (operand == "÷") {
        if (num2 != 0) {
            _output = (num1 / num2).toString();
        } else {
            _output = "Error"; // Manejar división por cero
        }
      }

      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else {
      _output = _output + buttonText;
    }

    // Limpia ceros iniciales
    if (_output.length > 1 && _output.startsWith('0') && _output != '0.') {
      _output = _output.substring(1);
    }
    
    // Si el resultado es un entero, lo muestra sin .0 (ej: 4.0 -> 4)
    if (_output.endsWith(".0")) {
      _output = _output.substring(0, _output.length - 2);
    }

    setState(() {
      output = _output;
    });
  }

  // Widget para crear los botones
  Widget buildButton(String buttonText, Color bgColor, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            backgroundColor: bgColor,
            padding: const EdgeInsets.all(20.0),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definición de colores
    final Color numColor = Colors.white;
    final Color opColor = Theme.of(context).colorScheme.secondary; // Verde para operadores
    final Color clearEqColor = Theme.of(context).colorScheme.primary; // Rojo para CLEAR y =
    final Color digitBg = Colors.black87; // Fondo oscuro para los números

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎄 Calculadora Navideña 🎁',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            // Pantalla de resultados
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 12.0,
                ),
                child: Text(
                  output,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Teclado
            Column(
              children: [
                // Fila 1: CLEAR, ÷, ×
                Row(
                  children: <Widget>[
                    buildButton("CLEAR", clearEqColor, numColor),
                    buildButton("÷", opColor, numColor),
                    buildButton("×", opColor, numColor),
                  ],
                ),
                // Fila 2: Números 7, 8, 9 y -
                Row(
                  children: <Widget>[
                    buildButton("7", digitBg, numColor),
                    buildButton("8", digitBg, numColor),
                    buildButton("9", digitBg, numColor),
                    buildButton("-", opColor, numColor),
                  ],
                ),
                // Fila 3: Números 4, 5, 6 y +
                Row(
                  children: <Widget>[
                    buildButton("4", digitBg, numColor),
                    buildButton("5", digitBg, numColor),
                    buildButton("6", digitBg, numColor),
                    buildButton("+", opColor, numColor),
                  ],
                ),
                // Fila 4: Números 1, 2, 3 y =
                Row(
                  children: <Widget>[
                    buildButton("1", digitBg, numColor),
                    buildButton("2", digitBg, numColor),
                    buildButton("3", digitBg, numColor),
                    buildButton("=", clearEqColor, numColor),
                  ],
                ),
                // Fila 5: Número 0 y punto decimal
                Row(
                  children: <Widget>[
                    buildButton("0", digitBg, numColor),
                    buildButton(".", digitBg, numColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
