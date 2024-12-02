package com.example.kotlin_listview_pokemon
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.enableEdgeToEdge
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import android.widget.ArrayAdapter
import android.widget.ListView
import android.os.Handler
import android.os.Looper
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread
import com.example.kotlin_listview_pokemon.ui.theme.Kotlin_listview_pokemonTheme

class MainActivity : ComponentActivity() {
    private lateinit var listView: ListView
    private val pokemonList = mutableListOf<String>()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)

        listView = findViewById(R.id.listViewPokemon)

        // Configurando o adaptador vazio inicialmente
        val adapter = ArrayAdapter(this, android.R.layout.simple_list_item_1, pokemonList)
        listView.adapter = adapter

        // Busca os dados da API em uma thread separada
        fetchPokemon {
            // Atualiza o adaptador na thread principal
            Handler(Looper.getMainLooper()).post {
                pokemonList.addAll(it)
                adapter.notifyDataSetChanged()
            }
        }
    }
}
private fun fetchPokemon(callback: (List<String>) -> Unit) {
    thread {
        try {
            val url = URL("https://pokeapi.co/api/v2/pokemon?limit=809")
            val connection = url.openConnection() as HttpURLConnection
            connection.requestMethod = "GET"

            // Lê a resposta da API
            val inputStream = connection.inputStream.bufferedReader().use { it.readText() }

            // Parse do JSON para obter a lista de nomes de Pokémon
            val jsonObject = JSONObject(inputStream)
            val results = jsonObject.getJSONArray("results")
            val names = mutableListOf<String>()
            for (i in 0 until results.length()) {
                val pokemon = results.getJSONObject(i)
                names.add(pokemon.getString("name"))
            }

            // Retorna os nomes via callback
            callback(names)
        } catch (e: Exception) {
            e.printStackTrace()
            callback(emptyList()) // Retorna lista vazia em caso de erro
        }
    }
}
@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    Kotlin_listview_pokemonTheme {
        Greeting("Android")
    }
}
data class Pokemon(val name: String)