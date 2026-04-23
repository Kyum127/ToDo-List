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
      title: 'ToDo Pro Max',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const TodoPage(),
    );
  }
}

class Tarea {
  String texto;
  bool completada;

  Tarea(this.texto, {this.completada = false});
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Tarea> tareas = [];
  final TextEditingController controller = TextEditingController();
  String filtro = "todas";

  void agregarTarea() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      tareas.insert(0, Tarea(controller.text.trim()));
      controller.clear();
    });
  }

  void eliminarTarea(Tarea tarea) {
    setState(() {
      tareas.remove(tarea);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tarea eliminada 🗑️")),
    );
  }

  void editarTarea(Tarea tarea) {
    final TextEditingController editController =
        TextEditingController(text: tarea.texto);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar tarea"),
        content: TextField(controller: editController),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tarea.texto = editController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  List<Tarea> obtenerTareasFiltradas() {
    if (filtro == "pendientes") {
      return tareas.where((t) => !t.completada).toList();
    } else if (filtro == "completadas") {
      return tareas.where((t) => t.completada).toList();
    }
    return tareas;
  }

  int tareasPendientes() {
    return tareas.where((t) => !t.completada).length;
  }

  @override
  Widget build(BuildContext context) {
    final lista = obtenerTareasFiltradas();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2FF),
      appBar: AppBar(
        elevation: 0,
        title: const Text("✨ ToDo Pro Max"),
        centerTitle: true,
      ),

      // BOTÓN FLOTANTE PRO
      floatingActionButton: FloatingActionButton(
        onPressed: agregarTarea,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // INPUT
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Escribe una tarea...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.task),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // FILTROS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              filtroBtn("todas"),
              filtroBtn("pendientes"),
              filtroBtn("completadas"),
            ],
          ),

          const SizedBox(height: 10),

          // CONTADOR PRO
          Text(
            "Pendientes: ${tareasPendientes()}",
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 10),

          // LISTA
          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text("No hay tareas 😴"))
                : ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final tarea = lista[index];

                      return Dismissible(
                        key: Key(tarea.texto + index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => eliminarTarea(tarea),
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
                            color: tarea.completada
                                ? Colors.green[100]
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
                            leading: Checkbox(
                              value: tarea.completada,
                              onChanged: (value) {
                                setState(() {
                                  tarea.completada = value ?? false;
                                });
                              },
                            ),
                            title: Text(
                              tarea.texto,
                              style: TextStyle(
                                decoration: tarea.completada
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),

                            // EDITAR + ELIMINAR
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => editarTarea(tarea),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => eliminarTarea(tarea),
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

  Widget filtroBtn(String tipo) {
    final activo = filtro == tipo;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            activo ? Colors.deepPurple : Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        setState(() {
          filtro = tipo;
        });
      },
      child: Text(
        tipo.toUpperCase(),
        style: TextStyle(
          color: activo ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}