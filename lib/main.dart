import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatTheHex?!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFf1f1f1),
      ),
      home: const ColorPickerPage(),
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  final TextEditingController _controller = TextEditingController(text: '#227BFE');
  Color _currentColor = const Color(0xFF227BFE);
  String _colorName = 'Shadow Blue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf1f1f1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildLogo(),
              const SizedBox(height: 20),
              _buildColorInput(),
              const SizedBox(height: 8),
              _buildInputLabel(),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildColorSwatch(),
                    const SizedBox(height: 16),
                    _buildColorInfo('RGBA', 'rgba(77, 81, 101, 1)'),
                    const SizedBox(height: 8),
                    _buildColorInfo('CSS', '--color-clear-blue: #227BFE;'),
                    const SizedBox(height: 8),
                    _buildColorInfo('SCSS', '\$color-clear-blue: #227BFE;'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildGenerateShadesButton(),
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '#',
              style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'WhatTheHex?!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildColorInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                if (value.length == 7 && value.startsWith('#')) {
                  setState(() {
                    _currentColor = Color(int.parse(value.substring(1, 7), radix: 16) + 0xFF000000);
                  });
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Colors.grey[900]),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _controller.text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied to clipboard')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel() {
    return Row(
      children: [
        Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey[900]),
        const SizedBox(width: 4),
        Text(
          'Type or pick a color and press enter',
          style: TextStyle(color: Colors.grey[900], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildColorSwatch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _colorName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            Text(
              'Closest name',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorInfo(String label, String value) {
    return Row(
      children: [
        Container(
          width: 60,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey[900],
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[900],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateShadesButton() {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.copy, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'GENERATE SHADES',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: () {
        print('Generate bro!');
      },
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Made with ',
          style: TextStyle(color: Colors.grey[900]),
        ),
        Icon(Icons.favorite, color: Colors.red, size: 16),
        Text(
          ' by Robinson Honour',
          style: TextStyle(color: Colors.grey[900]),
        ),
      ],
    );
  }
}

