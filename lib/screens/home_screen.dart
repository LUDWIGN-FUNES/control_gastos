import 'package:flutter/material.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> gastos = ["Supermercado - \$25", "Transporte - \$10", "Cena - \$30"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Gastos'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: gastos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(gastos[index]),
            leading: Icon(Icons.attach_money),
            trailing: Icon(Icons.edit),
            onTap: () {
              // Acción para editar/eliminar gasto
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

