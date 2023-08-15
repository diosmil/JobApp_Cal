import 'package:flutter/material.dart';

class LiquidacionTab extends StatefulWidget {
  @override
  _LiquidacionTabState createState() => _LiquidacionTabState();
}

class _LiquidacionTabState extends State<LiquidacionTab> {
  TextEditingController _fechaEntradaController = TextEditingController();
  TextEditingController _fechaSalidaController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();
  TextEditingController _horasExtrasController = TextEditingController();

  String _motivoSalida = 'Desahucio';
  bool _incluyePreaviso = false;
  bool _incluyeCesantia = false;
  bool _incluyeVacaciones = false;
  bool _incluyeSalarioNavidad = false;

  double _liquidacionTotal = 0.0;

  void _calcularLiquidacion() {
    DateTime fechaEntrada = DateTime.parse(_fechaEntradaController.text);
    DateTime fechaSalida = DateTime.parse(_fechaSalidaController.text);
    double salario = double.parse(_salarioController.text);
    double horasExtras = _horasExtrasController.text.isEmpty ? 0.0 : double.parse(_horasExtrasController.text);

    Duration tiempoDeServicio = fechaSalida.difference(fechaEntrada);
    int anosTrabajados = tiempoDeServicio.inDays ~/ 365;
    int mesesTrabajados = (tiempoDeServicio.inDays % 365) ~/ 30;

    double prestacionAnos = anosTrabajados * salario * 0.083; // 8.3% por año trabajado
    double prestacionMeses = mesesTrabajados * salario * 0.07; // 7% por mes trabajado
    double prestacionHorasExtras = horasExtras * salario * 0.028; // 2.8% por hora extra

    double cesantia = _incluyeCesantia ? (prestacionAnos + prestacionMeses) : 0.0;
    double vacaciones = _incluyeVacaciones ? (salario * 0.083 * anosTrabajados) : 0.0;
    double salarioNavidad = _incluyeSalarioNavidad ? (salario * 0.083 * mesesTrabajados) : 0.0;

    double prestacionTotal = prestacionAnos + prestacionMeses + prestacionHorasExtras + cesantia + vacaciones + salarioNavidad;

    setState(() {
      _liquidacionTotal = prestacionTotal;
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
      controller.text = fechaSeleccionada.toString().substring(0, 10);
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
            TextField(
              controller: _horasExtrasController,
              decoration: InputDecoration(labelText: 'Horas Extras'),
            ),
            DropdownButtonFormField<String>(
              value: _motivoSalida,
              items: [
                'Desahucio',
                'Despido',
                'Dimisión',
                'Renuncia',
                'Mutuo acuerdo',
                'Muerte del trabajador',
                'Jubilación del trabajador',
                'Incapacidad permanente del trabajador'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _motivoSalida = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Motivo de Salida'),
            ),
            CheckboxListTile(
              title: Text('Incluir Preaviso'),
              value: _incluyePreaviso,
              onChanged: (bool? newValue) {
                setState(() {
                  _incluyePreaviso = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Incluir Cesantía'),
              value: _incluyeCesantia,
              onChanged: (bool? newValue) {
                setState(() {
                  _incluyeCesantia = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Incluir Vacaciones'),
              value: _incluyeVacaciones,
              onChanged: (bool? newValue) {
                setState(() {
                  _incluyeVacaciones = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Incluir Salario de Navidad'),
              value: _incluyeSalarioNavidad,
              onChanged: (bool? newValue) {
                setState(() {
                  _incluyeSalarioNavidad = newValue!;
                });
              },
            ),
            ElevatedButton(
              child: Text('Calcular Liquidación'),
              onPressed: _calcularLiquidacion,
            ),
            Text(
              'Liquidación Total: \$${_liquidacionTotal.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


