import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(JogoAdiv());
}

class JogoAdiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GuessPage(),
    );
  }
}

class GuessPage extends StatefulWidget {
  @override
  _GuessPageState createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  late int _randomNumber;
  TextEditingController _controller = TextEditingController();
  String _feedback = '';
  bool _showFeedback = false;
  int _attempts = 0;
  final int _maxAttempts = 5;

  @override
  void initState() {
    super.initState();
    _generateRandomNumber();
  }

  void _generateRandomNumber() {
    final random = Random();
    _randomNumber = random.nextInt(100) + 1;
  }

  void _checkGuess(int guess) {
    _attempts++;

    if (_attempts >= _maxAttempts) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LostPage()),
      );
      return;
    }

    if (guess > _randomNumber) {
      setState(() {
        _feedback = 'Muito alto!';
        _showFeedback = true;
      });
    } else if (guess < _randomNumber) {
      setState(() {
        _feedback = 'Muito baixo!';
        _showFeedback = true;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WinnerPage()),
      );
    }
  }

  void _resetGame() {
    setState(() {
      _generateRandomNumber();
      _showFeedback = false;
      _controller.clear();
      _attempts = 0; // Reinicia o número de tentativas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adivinhe o Número'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tente adivinhar o número entre 1 e 100.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _showFeedback
                ? Text(
                    _feedback,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )
                : Container(),
            SizedBox(height: 20),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Digite um número',
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                int? guess = int.tryParse(_controller.text);
                if (guess != null) {
                  _checkGuess(guess);
                }
              },
              child: Text('Enviar'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}

class WinnerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parabéns!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Icon(
              Icons.thumb_up,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Você acertou!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class LostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tente Novamente'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_down,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
             Text(
              'Você excedeu o número máximo de tentativas.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volta para a página anterior
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
