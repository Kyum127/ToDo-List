import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notas App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const NotasPage(),
    );
  }
}

class Nota {
  String texto;
  bool favorita;

  Nota(this.texto, {this.favorita = false});
}

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final List<Nota> notas = [];
  final TextEditingController controller = TextEditingController();

  void agregarNota() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      notas.insert(0, Nota(controller.text.trim()));
      controller.clear();
    });
  }

  void eliminarNota(Nota nota) {
    setState(() {
      notas.remove(nota);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nota eliminada 🗑️")),
    );
  }

  void editarNota(Nota nota) {
    final editController = TextEditingController(text: nota.texto);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar nota"),
        content: TextField(controller: editController),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                nota.texto = editController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF9FF),
      appBar: AppBar(
        elevation: 0,
        title: const Text("📝 Notas Rápidas"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: agregarNota,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Escribe una nota...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: notas.isEmpty
                ? const Center(child: Text("No hay notas 😴"))
                : ListView.builder(
                    itemCount: notas.length,
                    itemBuilder: (context, index) {
                      final nota = notas[index];

                      return Dismissible(
                        key: Key(nota.texto + index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => eliminarNota(nota),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: nota.favorita
                                ? Colors.cyan[100]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: ListTile(
                            title: Text(nota.texto),

                            // FAVORITO ⭐
                            leading: IconButton(
                              icon: Icon(
                                nota.favorita
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                              ),
                              onPressed: () {
                                setState(() {
                                  nota.favorita = !nota.favorita;
                                });
                              },
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => editarNota(nota),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => eliminarNota(nota),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
