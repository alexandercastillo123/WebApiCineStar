using ConsumirApiCineStar.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Text.Json;

namespace ConsumirApiCineStarWeb.Controllers
{
    public class HomeController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly string _baseUrl = "https://localhost:7179/api/api/";

        public HomeController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        public IActionResult Index() => View(new CineViewModel());

        public async Task<IActionResult> Peliculas(int id = 1)
        {
            ViewBag.Titulo = (id == 1) ? "Cartelera" : "Próximos Estrenos";
            var client = _httpClientFactory.CreateClient();
            var response = await client.GetAsync($"{_baseUrl}peliculas/{id}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var list = JsonSerializer.Deserialize<List<Pelicula>>(json, options);
                return View(new CineViewModel { PeliculasCartelera = list ?? new() });
            }
            return View(new CineViewModel());
        }

        public async Task<IActionResult> Pelicula(int id)
        {
            var client = _httpClientFactory.CreateClient();
            var response = await client.GetAsync($"{_baseUrl}pelicula/{id}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var pelicula = JsonSerializer.Deserialize<Pelicula>(json, options);
                return View(new CineViewModel { PeliculaDetalle = pelicula });
            }
            return RedirectToAction("Index");
        }

        public async Task<IActionResult> Cines()
        {
            var client = _httpClientFactory.CreateClient();
            var response = await client.GetAsync($"{_baseUrl}cines");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var list = JsonSerializer.Deserialize<List<Cine>>(json, options);
                return View(new CineViewModel { Cines = list ?? new() });
            }
            return View(new CineViewModel());
        }

        public async Task<IActionResult> Cine(int id)
        {
            var client = _httpClientFactory.CreateClient();
            var response = await client.GetAsync($"{_baseUrl}cine/{id}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var model = JsonSerializer.Deserialize<CineViewModel>(json, options);
                return View(model);
            }
            return RedirectToAction("Cines");
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
