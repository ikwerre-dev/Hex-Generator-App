import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatTheHex?!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFf1f1f1),
      ),
      home: const ColorPickerPage(),
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  final TextEditingController _controller = TextEditingController(text: '#227BFE');
  Color _currentColor = const Color(0xFF227BFE);
  String _colorName = 'Shadow Blue';

  @override
  void initState() {
    super.initState();
    _updateColorFromHex(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateColorFromHex(String hexCode) {
    if (hexCode.length == 7 && hexCode.startsWith('#')) {
      setState(() {
        _currentColor = Color(int.parse(hexCode.substring(1, 7), radix: 16) + 0xFF000000);
        _colorName = _getColorName(_currentColor);
      });
    }
  }

  String _getColorName(Color color) {
    // this is just a temp color naming for the test
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    if (r > g && r > b) return 'Reddish';
    if (g > r && g > b) return 'Greenish';
    if (b > r && b > g) return 'Bluish';
    if (r == g && g == b) return 'Grayish';
    return 'Custom Color';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf1f1f1),
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
              _buildColorCard(),
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
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '#',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'WhatTheHex?!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _updateColorFromHex,
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _controller.text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            icon: Icon(Icons.copy, color: Colors.grey[900]),
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

  Widget _buildColorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColorSwatch(),
          const SizedBox(height: 16),
          _buildColorInfo('RGBA', 'rgba(${_currentColor.red}, ${_currentColor.green}, ${_currentColor.blue}, 1)'),
          const SizedBox(height: 8),
          _buildColorInfo('CSS', '--color-custom: ${_controller.text};'),
          const SizedBox(height: 8),
          _buildColorInfo('SCSS', '\$color-custom: ${_controller.text};'),
        ],
      ),
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
        const SizedBox(width: 8),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: () {
        print('Generate shades!');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            'GENERATE SHADES',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
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
        const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 16,
        ),
        Text(
          ' by Robinson Honour',
          style: TextStyle(color: Colors.grey[900]),
        ),
      ],
    );
  }
}

