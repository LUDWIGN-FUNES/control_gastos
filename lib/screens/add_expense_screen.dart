import 'package:flutter/material.dart';
import 'package:control_gastos/database/database_helper.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _category = "Alimentación";
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _guardarGasto() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final dbHelper = DatabaseHelper();
      final nuevoGasto = {
        'descripcion': _descriptionController.text.trim(),
        'categoria': _category,
        'monto': double.parse(_amountController.text),
        'fecha': _selectedDate!.toIso8601String(),
      };

      await dbHelper.insertGasto(nuevoGasto);
      Navigator.pop(context, true);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleccione una fecha para el gasto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Gasto')),
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
              Row(
                children: [
                  Text(
                    _selectedDate == null ? 'Seleccione fecha' : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarGasto,
                child: Text('Guardar Gasto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
