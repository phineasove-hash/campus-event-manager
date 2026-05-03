import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Event Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // couleur principale (sarcelle)
          secondary: Colors.deepPurple, // accent (violet foncé)
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const EventListScreen(),
    );
  }
}

// 1. Modèle de données (OOP en Dart)
class Event {
  final String title;
  final String date;
  final String description;

  Event({
    required this.title,
    required this.date,
    required this.description,
  });
}

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  // 2. Gestion de l'état asynchrone (Async Programming)[cite: 1]
  bool _isLoading = true; 
  
  // 3. Collection Dart (Liste)[cite: 1]
  List<Event> events = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialEvents();
  }

  // Simulation d'un délai réseau de 2 secondes[cite: 1]
  Future<void> _loadInitialEvents() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Une fois le délai passé, on met à jour l'interface avec setState[cite: 1]
    setState(() {
      events = [
        Event(
          title: "Hackathon 2026",
          date: "15 Mai 2026",
          description: "Competition of development and innovation for students across the campus.",
        ),
        Event(
          title: "Flutter Workshop",
          date: "20 Mai 2026",
          description: "Pratical session on Flutter development.",
        ),
        Event(
          title: "AI Conference",
          date: "25 Mai 2026",
          description: "Conference on artificial intelligence and its applications.",
        ),
      ];
      _isLoading = false; // Fin du chargement
    });
  }

  void _addEvent() {
    // 4. Validation avec conditions if (Control Loops / Logic)[cite: 1]
    if (_titleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() {
      events.add(Event(
        title: _titleController.text,
        date: _dateController.text,
        description: _descController.text,
      ));
    });

    _titleController.clear();
    _dateController.clear();
    _descController.clear();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event added successfully!')),
    );
  }

  void _deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deleted event successfully!')),
    );
  }

  // 5. Formulaire d'ajout (Input Fields & Forms)[cite: 1]
  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date (ex: 15 Mai 2026)'),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
            onPressed: _addEvent,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
        centerTitle: true,
        elevation: 2,
      ),
      // Si _isLoading est vrai, on affiche un indicateur de chargement[cite: 1]
      body: _isLoading 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Chargement des événements..."),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total des événements :',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          // Affichage du nombre total d'événements[cite: 1]
                          Text(
                            '${events.length}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: events.isEmpty
                      ? const Center(
                          child: Text(
                            'None event now. Please add some!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      // 6. Boucle de contrôle (ListView.builder)[cite: 1]
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: ListTile(
                                leading: Icon(Icons.event, color: Theme.of(context).colorScheme.primary, size: 40),
                                title: Text(
                                  event.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('📅 ${event.date}'),
                                    const SizedBox(height: 4),
                                    Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                                isThreeLine: true,
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteEvent(index), // Suppression[cite: 1]
                                ),
                                onTap: () {
                                  // 7. Affichage des détails au clic[cite: 1]
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(event.title),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Date: ${event.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 10),
                                          Text(event.description),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Fermer'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _isLoading 
          ? null // On cache le bouton pendant le chargement
          : FloatingActionButton(
              onPressed: _showAddEventDialog,
              tooltip: 'Ajouter un événement',
              child: const Icon(Icons.add),
          ),
    );
  }
}