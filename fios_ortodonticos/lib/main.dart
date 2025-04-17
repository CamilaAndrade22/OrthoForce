import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fios Ortodônticos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF499691),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

// Splash screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 226, 253),
      body: Center(
        child: Image.asset('assets/images/logo-ung.png', height: 230),
      ),
    );
  }
}

// Tela inicial
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WireTypeSelectionScreen()),
                    );
                  },
                  child: const Text(
                    'INICIAR',
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Seleção do tipo de fio
class WireTypeSelectionScreen extends StatefulWidget {
  @override
  _WireTypeSelectionScreenState createState() => _WireTypeSelectionScreenState();
}

class _WireTypeSelectionScreenState extends State<WireTypeSelectionScreen> {
  final List<String> wireTypes = [
    'Selecione um tipo de fio',
    'Aço 17x25',
    'NiTi 17x25',
    'TMA 17x25',
    'GM 17x25',
  ];

  String? _selectedWireType = 'Selecione um tipo de fio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tipo de Fio'), backgroundColor: Color(0xFF499691)),
      body: GradientContainer(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Escolha o tipo de fio:', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedWireType,
                decoration: InputDecoration(labelText: 'Tipo de fio'),
                onChanged: (value) {
                  setState(() {
                    _selectedWireType = value!;
                  });
                },
                items: wireTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _selectedWireType != null &&
                        _selectedWireType != 'Selecione um tipo de fio'
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WireThicknessSelectionScreen(
                              selectedWireType: _selectedWireType!,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text('Avançar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Seleção de espessura e cálculo de força
class WireThicknessSelectionScreen extends StatefulWidget {
  final String selectedWireType;

  WireThicknessSelectionScreen({required this.selectedWireType});

  @override
  _WireThicknessSelectionScreenState createState() =>
      _WireThicknessSelectionScreenState();
}

class _WireThicknessSelectionScreenState extends State<WireThicknessSelectionScreen> {
  String _selectedThickness = 'Selecione uma espessura';

  final List<String> thicknessOptions = [
    'Selecione uma espessura',
    '0.1', '0.2', '0.3', '0.4', '0.5',
    '0.6', '0.7', '0.8', '0.9', '1.0',
    '1.1', '1.2', '1.3', '1.4', '1.5',
    '1.6', '1.7', '1.8', '1.9', '2.0',
  ];

  final Map<String, Map<String, double>> parametrosFios = {
    'Aço 17x25':   {'y0': -1.07,   'plateau': 27.73, 'k': 1.235},
    'GM 17x25':    {'y0': -0.3932, 'plateau': 14.97, 'k': 0.6472},
    'TMA 17x25':   {'y0': -0.6679, 'plateau': 20.85, 'k': 0.715},
    'NiTi 17x25':  {'y0': -0.2214, 'plateau': 4.22,  'k': 2.576},
  };

  double calcularForca(double y0, double plateau, double k, double x) {
    return (y0 - plateau) * exp(-k * x) + plateau;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Espessura do Fio'), backgroundColor: Color(0xFF499691)),
      body: GradientContainer(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Escolha a espessura do fio:', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedThickness,
                decoration: InputDecoration(labelText: 'Espessura (mm)'),
                onChanged: (value) {
                  setState(() {
                    _selectedThickness = value!;
                  });
                },
                items: thicknessOptions.map((thickness) {
                  return DropdownMenuItem(
                    value: thickness,
                    child: Text(thickness == 'Selecione uma espessura' ? thickness : '$thickness mm'),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _selectedThickness != 'Selecione uma espessura'
                    ? () {
                        double x = double.parse(_selectedThickness);
                        var params = parametrosFios[widget.selectedWireType]!;
                        double resultado = calcularForca(
                          params['y0']!,
                          params['plateau']!,
                          params['k']!,
                          x,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              tipoFio: widget.selectedWireType,
                              espessura: _selectedThickness,
                              forca: resultado,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text('Ver Recomendação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela de resultado
class ResultScreen extends StatelessWidget {
  final String tipoFio;
  final String espessura;
  final double forca;

  ResultScreen({required this.tipoFio, required this.espessura, required this.forca});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado'), backgroundColor: Color(0xFF499691)),
      body: GradientContainer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Fio selecionado:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$tipoFio - $espessura mm',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Força estimada:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${forca.toStringAsFixed(2)} gf',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
       onPressed: () {
       Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WireTypeSelectionScreen()),
     );
   },
  style: ElevatedButton.styleFrom(
    minimumSize: Size(200, 50), // tamanho mínimo do botão
  ),
  child: FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      'CALCULAR NOVAMENTE',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
  ],
   ),
    ),
   ),
    ),
      ),
      ),
    );
  }
}

// Container com gradiente
class GradientContainer extends StatelessWidget {
  final Widget child;

  const GradientContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE0FFFF),
            Color(0xFFB2EBF2),
            Color(0xFF80DEEA),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
