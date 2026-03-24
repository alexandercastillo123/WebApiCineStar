using Microsoft.AspNetCore.Mvc;
using WebApiCineStar.Controllers.dao;

namespace WebApiCineStar.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PeliculaController : ControllerBase
    {
        private daoPelicula _daoPelicula = new daoPelicula();

        [HttpGet("verPeliculas/{id}")]
        public IActionResult GetPeliculas(int id)
        {
            var res = _daoPelicula.getPeliculas(id);
            return Ok(res);
        }

        [HttpGet("verPelicula/{id}")]
        public IActionResult GetPelicula(int id)
        {
            var res = _daoPelicula.getPelicula(id);
            if (res == null) return NotFound();
            return Ok(res);
        }
    }
}
