using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
namespace maui_listview_pokemon
{
    public partial class MainPage : ContentPage
    {
        public List<string> PokemonList { get; set; }

        public MainPage()
        {
            InitializeComponent();
            BindingContext = this;
            LoadPokemonAsync();
        }

        private async Task LoadPokemonAsync()
        {
            try
            {
                using var client = new HttpClient();
                var response = await client.GetStringAsync("https://pokeapi.co/api/v2/pokemon?limit=809");
                var options = new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true,
                };
                var pokemonData = JsonSerializer.Deserialize<PokemonResponse>(response, options);

                PokemonList = pokemonData.Results.Select(p => p.Name).ToList();
                OnPropertyChanged(nameof(PokemonList));
            }
            catch (Exception ex)
            {
                await DisplayAlert("Erro", $"Erro ao carregar Pokémon: {ex.Message}", "OK");
            }
        }

        public class PokemonResponse
        {
            public List<Pokemon> Results { get; set; }
        }

        public class Pokemon
        {
            public string Name { get; set; }
        }
    }

}
