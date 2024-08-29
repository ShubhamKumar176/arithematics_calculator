import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _controller = TextEditingController();
  String _result = '';
  String _selectedConversion = 'Length';

  final Map<String, Map<String, double>> _conversionRates = {
    'Length': {
      'Meter to Kilometer': 0.001,
      'Kilometer to Meter': 1000.0,
      'Meter to Centimeter': 100.0,
      'Centimeter to Meter': 0.01,
    },
    // Add other categories similarly...
  };

  void _convert() {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _result = 'Invalid Input';
      });
      return;
    }

    final conversion = _conversionRates[_selectedConversion];
    if (conversion != null) {
      final result = conversion.entries.map((entry) {
        final convertedValue = input * entry.value;
        return '${entry.key}: ${convertedValue.toStringAsFixed(2)}';
      }).join('\n');
      setState(() {
        _result = result;
      });
    } else {
      setState(() {
        _result = 'Conversion not available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _selectedConversion,
              items: _conversionRates.keys.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedConversion = value!;
                  _result = '';
                });
              },
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 16.0),
            Text(
              _result,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
