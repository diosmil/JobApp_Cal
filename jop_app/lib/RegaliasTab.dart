import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    setState(() {
      String fechaEntrada = _fechaEntradaController.text;
      String fechaSalida = _fechaSalidaController.text;

      DateTime inicio = DateTime.parse(fechaEntrada);
      DateTime fin = DateTime.parse(fechaSalida);

      Duration diferencia = fin.difference(inicio);
      int mesesTrabajados = (diferencia.inDays / 30.44).round(); // Meses trabajados aproximados

      double salarioMensual = double.parse(_salarioController.text);

      double regalia = (salarioMensual * mesesTrabajados) / 12;

      _regalia = regalia;
    });
  }

  void _seleccionarFecha(TextEditingController controller) async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (fechaSeleccionada != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(fechaSeleccionada);
    }
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
              readOnly: true,
              onTap: () => _seleccionarFecha(_fechaEntradaController),
            ),
            TextField(
              controller: _fechaSalidaController,
              decoration: InputDecoration(labelText: 'Fecha de Salida'),
              readOnly: true,
              onTap: () => _seleccionarFecha(_fechaSalidaController),
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
              'Regalía Calculada: \$${_regalia.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}


