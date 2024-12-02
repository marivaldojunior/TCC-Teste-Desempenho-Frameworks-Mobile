import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PokemonListApp());
}

class PokemonListApp extends StatelessWidget {
  const PokemonListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Pokémon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PokemonListPage(),
    );
  }
}

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late Future<List<Map<String, dynamic>>> _pokemonList;

  @override
  void initState() {
    super.initState();
    _pokemonList = fetchPokemon();
  }

  Future<List<Map<String, dynamic>>> fetchPokemon() async {
    const url = 'https://pokeapi.co/api/v2/pokemon?limit=649';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      // Adiciona o índice como número do Pokémon
      return results
          .asMap()
          .entries
          .map((entry) => {
                'name': entry.value['name'],
                'number': entry.key +
                    1, // Índice + 1 para corresponder ao ID do Pokémon
              })
          .toList();
    } else {
      throw Exception('Falha ao carregar os Pokémon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokémon'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pokemonList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum Pokémon encontrado'));
          } else {
            final pokemonList = snapshot.data!;
            return ListView.builder(
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonList[index];
                final number = pokemon['number']
                    .toString()
                    .padLeft(3, '0'); // Formata como "001", "002", etc.
                final name = pokemon['name'];
                final pngImage = 'assets/images/${number}MS.png';
                final gifImage = 'assets/images/$number.gif';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Primeira coluna: PNG
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            pngImage,
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Segunda coluna: Texto
                        Expanded(
                          flex: 2,
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Terceira coluna: GIF
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            gifImage,
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
