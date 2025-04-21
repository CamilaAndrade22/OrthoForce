import 'package:flutter/material.dart';
import 'dart:math';

// Ponto de entrada da aplicação
void main() {
  runApp(MyApp());
}

// Widget principal da aplicação
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
      home: SplashScreen(), // Primeira tela exibida
    );
  }
}

// Tela de Splash (tela inicial de carregamento)
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navega para a tela principal após 07 segundos
    Future.delayed(Duration(seconds: 7), () {
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
        child: Image.asset('assets/images/logo-ung.png', height: 230), // Logo na tela
      ),
    );
  }
}

// Tela inicial principal
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer( // Container com fundo gradiente
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
                  // Botão para iniciar o app
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

// Tela de seleção do tipo de fio
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

  String? _selectedWireType = 'Selecione um tipo de fio'; // Tipo de fio selecionado

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
                // Lista de tipos de fio
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
                // Avança apenas se um tipo de fio for selecionado
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

// Tela de seleção de espessura do fio e cálculo
class WireThicknessSelectionScreen extends StatefulWidget {
  final String selectedWireType; // Tipo de fio selecionado vindo da tela anterior

  WireThicknessSelectionScreen({required this.selectedWireType});

  @override
  _WireThicknessSelectionScreenState createState() => _WireThicknessSelectionScreenState();
}

class _WireThicknessSelectionScreenState extends State<WireThicknessSelectionScreen> {
  String _selectedThickness = 'Selecione uma espessura'; // Espessura selecionada
  bool _usarValorPersonalizado = false; // Flag para usar valor manual
  final TextEditingController _espessuraController = TextEditingController(); // Controller para valor manual

  // Lista de opções pré-definidas de espessura
  final List<String> thicknessOptions = [
    'Selecione uma espessura',
    '0.1', '0.2', '0.3', '0.4', '0.5',
    '0.6', '0.7', '0.8', '0.9', '1.0',
    '1.1', '1.2', '1.3', '1.4', '1.5',
    '1.6', '1.7', '1.8', '1.9', '2.0',
  ];

  // Parâmetros de cálculo para cada tipo de fio
  final Map<String, Map<String, double>> parametrosFios = {
    'Aço 17x25':   {'y0': -1.07,   'plateau': 27.73, 'k': 1.235},
    'GM 17x25':    {'y0': -0.3932, 'plateau': 14.97, 'k': 0.6472},
    'TMA 17x25':   {'y0': -0.6679, 'plateau': 20.85, 'k': 0.715},
    'NiTi 17x25':  {'y0': -0.2214, 'plateau': 4.22,  'k': 2.576},
  };

  // Função que calcula a força estimada com base nos parâmetros e espessura
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

              // Dropdown para espessura padrão
              if (!_usarValorPersonalizado)
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

              // Campo para espessura personalizada
              if (_usarValorPersonalizado)
                TextFormField(
                  controller: _espessuraController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Digite a espessura (mm)'),
                ),

              // Checkbox para alternar entre as opções
              Row(
                children: [
                  Checkbox(
                    value: _usarValorPersonalizado,
                    onChanged: (value) {
                      setState(() {
                        _usarValorPersonalizado = value!;
                      });
                    },
                  ),
                  Text('Inserir valor personalizado'),
                ],
              ),

              SizedBox(height: 30),
              ElevatedButton(
                // Botão para calcular a força estimada
                onPressed: () {
                  double? x;

                  if (_usarValorPersonalizado) {
                    x = double.tryParse(_espessuraController.text);
                    if (x == null || x <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Insira um valor válido para espessura.')),
                      );
                      return;
                    }
                  } else if (_selectedThickness != 'Selecione uma espessura') {
                    x = double.parse(_selectedThickness);
                  }

                  if (x != null) {
                    var params = parametrosFios[widget.selectedWireType]!;
                    double resultado = calcularForca(params['y0']!, params['plateau']!, params['k']!, x);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          tipoFio: widget.selectedWireType,
                          espessura: x!.toStringAsFixed(2),
                          forca: resultado,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Ver Recomendação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela que mostra o resultado final do cálculo
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
                    Text('Fio selecionado:', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('$tipoFio - $espessura MM',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 24),
                    Text('Força estimada:', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('${forca.toStringAsFixed(2)} GF',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Botão para voltar e calcular novamente
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => WireTypeSelectionScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'CALCULAR NOVAMENTE',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

// Widget que cria um fundo gradiente reutilizável
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

