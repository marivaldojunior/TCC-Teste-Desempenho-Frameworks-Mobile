/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  FlatList,
  StyleSheet,
  ActivityIndicator,
} from 'react-native';

const App = () => {
  const [pokemonList, setPokemonList] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Função para buscar Pokémon da API
    const fetchPokemon = async () => {
      try {
        const response = await fetch('https://pokeapi.co/api/v2/pokemon?limit=809');
        const json = await response.json();
        const names = json.results.map((pokemon) => pokemon.name);
        setPokemonList(names);
      } catch (error) {
        console.error('Erro ao buscar Pokémon:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchPokemon();
  }, []);

  return (
    <View style={styles.container}>
      {/* Título */}
      <Text style={styles.title}>Lista de Pokémon</Text>

      {/* Indicador de carregamento */}
      {loading ? (
        <ActivityIndicator size="large" color="#00ff00" />
      ) : (
        // FlatList para exibir os nomes
        <FlatList
          data={pokemonList}
          keyExtractor={(item, index) => index.toString()}
          renderItem={({ item }) => <Text style={styles.item}>{item}</Text>}
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 16,
  },
  item: {
    fontSize: 18,
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#ddd',
  },
});

export default App;

