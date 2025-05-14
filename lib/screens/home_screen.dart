import 'package:control_gastos/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:control_gastos/screens/add_expense_screen.dart';
import 'package:control_gastos/screens/edit_expense_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> gastos = [];

  @override
  void initState() {
    super.initState();
    _loadGastos();
  }

  void _loadGastos() async {
    final dbHelper = DatabaseHelper();
    final datos = await dbHelper.getGastos();

    print("Gastos recuperados desde SQLite: $datos");

    setState(() {
      gastos = datos;
    });
  }

  double _calcularTotalGastos() {
    double total = 0;
    for (var gasto in gastos) {
      total += gasto['monto'];
    }
    return total;
  }

  void _eliminarGasto(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteGasto(id);
    _loadGastos();
  }

  void _mostrarConfirmacionEliminacion(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Gasto'),
          content: Text('¿Estás seguro de que quieres eliminar este gasto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarGasto(id);
                Navigator.pop(context);
              },
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Color _obtenerColorCategoria(String categoria) {
    switch (categoria) {
      case "Alimentación":
        return Colors.green;
      case "Transporte":
        return Colors.blue;
      case "Ocio":
        return Colors.orange;
      case "Otros":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  IconData _obtenerIconoCategoria(String categoria) {
    switch (categoria) {
      case "Alimentación":
        return Icons.restaurant;
      case "Transporte":
        return Icons.directions_car;
      case "Ocio":
        return Icons.movie;
      case "Otros":
        return Icons.category;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Gastos'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Total Gastos: \$${_calcularTotalGastos().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: gastos.isEmpty
                ? Center(
                    child: Text(
                      'No hay gastos registrados.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: gastos.length,
                    itemBuilder: (context, index) {
                      DateTime fecha = DateTime.parse(gastos[index]['fecha']);
                      String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(
                            gastos[index]['descripcion'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${gastos[index]['categoria']} - \$${gastos[index]['monto']}\nFecha: $fechaFormateada',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          leading: Icon(
                            _obtenerIconoCategoria(gastos[index]['categoria']),
                            color: _obtenerColorCategoria(gastos[index]['categoria']),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blueAccent),
                                onPressed: () async {
                                  final resultado = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditExpenseScreen(gasto: gastos[index])),
                                  );
                                  if (resultado == true) {
                                    _loadGastos();
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () {
                                  _mostrarConfirmacionEliminacion(context, gastos[index]['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
          if (resultado == true) {
            _loadGastos();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
