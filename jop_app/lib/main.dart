import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p; // Usa p como alias para el paquete path
import 'package:flutter/widgets.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      p.join(await getDatabasesPath(), 'user_database.db'), // Usa p.join para usar el paquete path
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _login() async {
    final users = await _database!.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [_usernameController.text, _passwordController.text],
    );

    if (users.isNotEmpty) {
      // Comprueba si el widget está montado antes de usar el contexto
      if (mounted) {
        Navigator.push(
          context, // Usa context como un BuildContext
          // Usa el constructor de la clase MainScreen para crear un widget
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    }
  }

  Future<void> _register() async {
    await _database!.insert(
      'users',
      {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    showDialog(
      context: context, // Usa context como un BuildContext
      builder: (context) {
        return AlertDialog(
          title: Text('Registro Exitoso'),
          content: Text('Usuario registrado con éxito.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Calculator'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Regalías'),
              Tab(text: 'Liquidación'),
              Tab(text: 'Retenciones'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RegaliasTab(),
            LiquidacionTab(),
            RetencionesTab(),
          ],
        ),
      ),
    );
  }
}

class RegaliasTab extends StatefulWidget {
  @override
  _RegaliasTabState createState() => _RegaliasTabState();
}

class _RegaliasTabState extends State<RegaliasTab> {
  TextEditingController _fechaEntradaController = TextEditingController();
  TextEditingController _fechaSalidaController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();

  double _regalia = 0.0;

  void _calcularRegalia() {
    // Implementa los cálculos de regalía aquí
    setState(() {
      // Calcula el valor de la regalía y actualiza el estado
      // _regalia = ...;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _fechaEntradaController,
              decoration: InputDecoration(labelText: 'Fecha de Entrada'),
            ),
            TextField(
              controller: _fechaSalidaController,
              decoration: InputDecoration(labelText: 'Fecha de Salida'),
            ),
            TextField(
              controller: _salarioController,
              decoration: InputDecoration(labelText: 'Salario'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calcularRegalia,
              child: Text('Calcular Regalía'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Regalía Calculada: $_regalia',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

class LiquidacionTab extends StatefulWidget {
  @override
  _LiquidacionTabState createState() => _LiquidacionTabState();
}

class _LiquidacionTabState extends State<LiquidacionTab> {
  TextEditingController _fechaEntradaController = TextEditingController();
  TextEditingController _fechaSalidaController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();
  bool _incluyePreaviso = false;
  bool _incluyeCesantia = false;
  bool _incluyeVacaciones = false;
  bool _incluyeSalarioNavidad = false;

  double _liquidacionTotal = 0.0;

  void _calcularLiquidacion() {
    // Implementa los cálculos de liquidación aquí
    setState(() {
      // Calcula el valor de la liquidación y actualiza el estado
      // _liquidacionTotal = ...;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _fechaEntradaController,
              decoration: InputDecoration(labelText: 'Fecha de Entrada'),
            ),
            TextField(
              controller: _fechaSalidaController,
              decoration: InputDecoration(labelText: 'Fecha de Salida'),
            ),
            TextField(
              controller: _salarioController,
              decoration: InputDecoration(labelText: 'Salario'),
            ),
            CheckboxListTile(
              title: Text('Incluir Preaviso'),
              value: _incluyePreaviso,
              onChanged: (value) {
                setState(() {
                  _incluyePreaviso = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Incluir Cesantía'),
              value: _incluyeCesantia,
              onChanged: (value) {
                setState(() {
                  _incluyeCesantia = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Incluir Vacaciones'),
              value: _incluyeVacaciones,
              onChanged: (value) {
                setState(() {
                  _incluyeVacaciones = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Incluir Salario de Navidad'),
              value: _incluyeSalarioNavidad,
              onChanged: (value) {
                setState(() {
                  _incluyeSalarioNavidad = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calcularLiquidacion,
              child: Text('Calcular Liquidación'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Liquidación Calculada: $_liquidacionTotal',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

class RetencionesTab extends StatefulWidget {
  @override
  _RetencionesTabState createState() => _RetencionesTabState();
}

class _RetencionesTabState extends State<RetencionesTab> {
  TextEditingController _salarioController = TextEditingController();
  TextEditingController _comisionController = TextEditingController();

  double _isr = 0.0;
  double _sfs = 0.0;
  double _afp = 0.0;
  double _descuento = 0.0;
  double _retencionNeta = 0.0;

  void _calcularRetenciones() {
    // Implementa los cálculos de retenciones aquí
    setState(() {
      // Calcula los montos de ISR, SFS, AFP, descuento y retención neta
      // _isr = ...;
      // _sfs = ...;
      // _afp = ...;
      // _descuento = ...;
      // _retencionNeta = ...;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _salarioController,
              decoration: InputDecoration(labelText: 'Salario'),
            ),
            TextField(
              controller: _comisionController,
              decoration: InputDecoration(labelText: 'Comisión'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calcularRetenciones,
              child: Text('Calcular Retenciones'),
            ),
            SizedBox(height: 16.0),
            Text(
              'ISR: $_isr',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'SFS: $_sfs',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'AFP: $_afp',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Descuento: $_descuento',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Retención Neta: $_retencionNeta',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

