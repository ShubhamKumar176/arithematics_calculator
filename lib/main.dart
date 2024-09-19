import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp()); 
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      themeMode: ThemeMode.system,
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _expression = '';
  String _result = '0';
  List<String> _history = [];

  void _numClick(String text) {
    setState(() {
      _expression += text;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  void _delete() {
    setState(() {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    });
  }

  void _evaluate() {
    Parser p = Parser();
    try {
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = eval.toStringAsFixed(2);
        _history.add('$_expression = $_result');
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(history: _history),
      ),
    );
  }
   
  void _openConverter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnitConverterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openSettings,
          ),
          IconButton(
            icon: Icon(Icons.transform),
            onPressed: _openConverter,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black87
                  : Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 24, color: Colors.grey[700]),
                  ),
                  Text(
                    _result,
                    style: TextStyle(fontSize: 48, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          _buildButtonGrid(),
        ],
      ),
    );
  }

  Widget _buildButtonGrid() {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.2,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          return _buildButton(buttons[index]);
        },
      ),
    );
  }

  Widget _buildButton(String text) {
    return GestureDetector(
      onTap: () {
        switch (text) {
          case 'C':
            _clear();
            break;
          case 'DEL':
            _delete();
            break;
          case '=':
            _evaluate();
            break;
          default:
            _numClick(text);
            break;
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _getColor(text),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Color _getColor(String text) {
    switch (text) {
      case 'C':
      case 'DEL':
        return Colors.red;
      case '=':
        return Colors.green;
      case '+':
      case '-':
      case '*':
      case '/':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }
}

class SettingsScreen extends StatelessWidget {
  final List<String> history;

  SettingsScreen({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('History'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: history.map((item) => Text(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class UnitConverterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
      ),
      body: ListView(
        children: [
          _buildConverterTile(context, 'Length'),
          _buildConverterTile(context, 'Speed'),
          _buildConverterTile(context, 'Area'),
          _buildConverterTile(context, 'Currency'),
          _buildConverterTile(context, 'Time'),
          _buildConverterTile(context, 'Discount'),
          _buildConverterTile(context, 'Mass'),
          _buildConverterTile(context, 'Data'),
          _buildConverterTile(context, 'GST'),
        ],
      ),
    );
  }

  Widget _buildConverterTile(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversionScreen(conversionType: title),
          ),
        );
      },
    );
  }
}

class ConversionScreen extends StatefulWidget {
  final String conversionType;

  ConversionScreen({required this.conversionType});

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _result = '';

  void _convert() {
    setState(() {
      double input = double.tryParse(_inputController.text) ?? 0.0;
      _result = (input * _getConversionFactor(widget.conversionType))
          .toStringAsFixed(2);
    });
  }

  double _getConversionFactor(String conversionType) {
    // Define your conversion factors here.
    switch (conversionType) {
      case 'Length':
        return 0.001; // Example: Meters to Kilometers
      case 'Speed':
        return 3.6; // Example: m/s to km/h
      case 'Area':
        return 0.0001; // Example: Square meters to hectares
      case 'Currency':
        return 0.013; // Example: INR to USD (mock rate)
      case 'Time':
        return 60; // Example: Minutes to seconds
      case 'Discount':
        return 0.9; // Example: 10% discount
      case 'Mass':
        return 1000; // Example: Grams to Kilograms
      case 'Data':
        return 0.001; // Example: KB to MB
      case 'GST':
        return 1.18; // Example: Applying 18% GST
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.conversionType} Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter value to convert'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            Text(
              'Result: $_result',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> buttons = [
  'C',
  'DEL',
  '%',
  '/',
  '7',
  '8',
  '9',
  '*',
  '4',
  '5',
  '6',
  '-',
  '1',
  '2',
  '3',
  '+',
  '0',
  '.',
  '^',
  '='
];
