import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF17181A),
        primarySwatch: Colors.deepOrange,
      ),
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _output = '0';
  String _currentNumber = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  bool _isNewOperation = false;

  // Manejo de botones presionado
  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _currentNumber = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isNewOperation = false;
      } else if (buttonText == '⌫') {
        if (_currentNumber.isNotEmpty) {
          _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
          _output = _currentNumber.isEmpty ? '0' : _currentNumber;
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        if (_currentNumber.isNotEmpty) {
          _num1 = double.parse(_currentNumber);
        } else if (_output != '0' && !_isNewOperation) {
          _num1 = double.parse(_output);
        }
        _operand = buttonText;
        _isNewOperation = true;
        _currentNumber = '';
      } else if (buttonText == '.') {
        if (_isNewOperation) {
          _currentNumber = '0.';
          _output = '0.';
          _isNewOperation = false;
        } else if (!_currentNumber.contains('.')) {
          _currentNumber = _currentNumber.isEmpty ? '0.' : _currentNumber + '.';
          _output = _currentNumber;
        }
      } else if (buttonText == '±') {
        if (_output != '0') {
          if (_output.startsWith('-')) {
            _output = _output.substring(1);
          } else {
            _output = '-$_output';
          }
          _currentNumber = _output;
        }
      } else if (buttonText == '%') {
        if (_output != '0') {
          double val = double.parse(_output) / 100;
          _output = _formatResult(val);
          _currentNumber = _output;
        }
      } else if (buttonText == '=') {
        if (_operand.isNotEmpty && _currentNumber.isNotEmpty) {
          _num2 = double.parse(_currentNumber);
          double result = 0;

          switch (_operand) {
            case '+':
              result = _num1 + _num2;
              break;
            case '-':
              result = _num1 - _num2;
              break;
            case '×':
              result = _num1 * _num2;
              break;
            case '÷':
              if (_num2 == 0) {
                _output = 'Error';
                _currentNumber = '';
                _operand = '';
                return;
              }
              result = _num1 / _num2;
              break;
          }

          _output = _formatResult(result);
          _currentNumber = _output;
          _operand = '';
          _isNewOperation = true;
        }
      } else {
        // Números del 0 al 9
        if (_isNewOperation) {
          _currentNumber = buttonText;
          _isNewOperation = false;
        } else {
          _currentNumber = _currentNumber == '0' ? buttonText : _currentNumber + buttonText;
        }
        _output = _currentNumber;
      }
    });
  }

  // Evita decimales innecesarios (ej. mostrar '5' en lugar de '5.0')
  String _formatResult(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  // Constructor de botones personalizados
  Widget _buildButton(String text, {Color? textColor, Color? bgColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 22),
            backgroundColor: bgColor ?? const Color(0xFF26282C),
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Flutter'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pantalla de resultados
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                reverse: true,
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFF2B2D31)),
          // Panel de botones
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('C', textColor: const Color(0xFFFF6B6B), bgColor: const Color(0xFF2D2323)),
                    _buildButton('±', textColor: const Color(0xFF4ECDC4), bgColor: const Color(0xFF1E2D2D)),
                    _buildButton('%', textColor: const Color(0xFF4ECDC4), bgColor: const Color(0xFF1E2D2D)),
                    _buildButton('÷', textColor: const Color(0xFFFFA500), bgColor: const Color(0xFF2D261E)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', textColor: const Color(0xFFFFA500), bgColor: const Color(0xFF2D261E)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', textColor: const Color(0xFFFFA500), bgColor: const Color(0xFF2D261E)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', textColor: const Color(0xFFFFA500), bgColor: const Color(0xFF2D261E)),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('⌫', textColor: const Color(0xFFFFA500), bgColor: const Color(0xFF26282C)),
                    _buildButton('=', textColor: Colors.white, bgColor: const Color(0xFFFFA500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}