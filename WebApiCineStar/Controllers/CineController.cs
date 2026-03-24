using Microsoft.AspNetCore.Mvc;
using WebApiCineStar.Controllers.dao;

namespace WebApiCineStar.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CineController : ControllerBase
    {
        private daoCine _daoCine = new daoCine();

        [HttpGet("verCines")]
        public IActionResult GetCines()
        {
            var res = _daoCine.getVerCines();
            return Ok(res);
        }

        [HttpGet("verCine/{id}")]
        public IActionResult GetCine(int id)
        {
            var res = _daoCine.getCine(id);
            if (res == null) return NotFound();
            return Ok(res);
        }
    }
}
