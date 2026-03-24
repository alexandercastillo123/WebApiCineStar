using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using System.Collections.Generic;
using ConsumirApiCineStarWeb.Models;

namespace ConsumirApiCineStarWeb.Controllers
{
    public class HomeController : Controller
    {
        private readonly HttpClient _httpClient;
        private readonly string _apiBaseUrl = "https://localhost:7179/api/";

        public HomeController()
        {
            var handler = new HttpClientHandler
            {
                ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => true
            };
            _httpClient = new HttpClient(handler);
            _httpClient.BaseAddress = new System.Uri(_apiBaseUrl);
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> Cines()
        {
            var response = await _httpClient.GetAsync("Cine/verCines");
            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var cines = JsonSerializer.Deserialize<List<Cine>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return View(cines);
            }
            return View(new List<Cine>());
        }

        public async Task<IActionResult> Cine(int id)
        {
            var response = await _httpClient.GetAsync($"Cine/verCine/{id}");
            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var cine = JsonSerializer.Deserialize<Cine>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return View(cine);
            }
            return View(new Cine());
        }

        public async Task<IActionResult> Peliculas(int id)
        {
            var response = await _httpClient.GetAsync($"Pelicula/verPeliculas/{id}");
            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var peliculas = JsonSerializer.Deserialize<List<Pelicula>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return View(peliculas);
            }
            return View(new List<Pelicula>());
        }

        public async Task<IActionResult> Pelicula(int id)
        {
            var response = await _httpClient.GetAsync($"Pelicula/verPelicula/{id}");
            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var pelicula = JsonSerializer.Deserialize<Pelicula>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return View(pelicula);
            }
            return View(new Pelicula());
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
