import 'package:flutter/material.dart';
import 'package:control_gastos/database/database_helper.dart';

class EditExpenseScreen extends StatefulWidget {
  final Map<String, dynamic> gasto;

  EditExpenseScreen({required this.gasto});

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  String _category = "";

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.gasto['descripcion']);
    _amountController = TextEditingController(text: widget.gasto['monto'].toString());
    _category = widget.gasto['categoria'];
  }

  void _updateGasto() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DatabaseHelper();
      final gastoActualizado = {
        'id': widget.gasto['id'],
        'descripcion': _descriptionController.text.trim(),
        'categoria': _category,
        'monto': double.parse(_amountController.text),
        'fecha': widget.gasto['fecha'], // Mantener la fecha original
      };

      await dbHelper.updateGasto(gastoActualizado);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Gasto')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.trim().isEmpty ? 'Ingrese una descripción válida' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final monto = double.tryParse(value!);
                  if (monto == null || monto <= 0) {
                    return 'Ingrese un monto válido y mayor a cero';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items: ["Alimentación", "Transporte", "Ocio", "Otros"]
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateGasto,
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
