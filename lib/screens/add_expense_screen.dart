class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _category = "Alimentación";

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
                validator: (value) => value!.isEmpty ? 'Ingrese una descripción' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) => (double.tryParse(value!) == null || value.isEmpty)
                    ? 'Ingrese un monto válido'
                    : null,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí se guardaría el gasto en una lista o base de datos
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar Gasto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

