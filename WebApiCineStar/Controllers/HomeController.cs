using WebApiCineStar.Models;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace CineStarWeb.Controllers
{
    public class HomeControllerApi : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;

        public HomeControllerApi(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        public async Task<IActionResult> Cine(int id)
        {
            var client = _httpClientFactory.CreateClient();
            var response = await client.GetAsync($"https://localhost:7214/api/api/cine/{id}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();

                var opciones = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var model = JsonSerializer.Deserialize<CineViewModel>(json, opciones);

                return View(model);
            }

            return NotFound();
        }
    }
}
