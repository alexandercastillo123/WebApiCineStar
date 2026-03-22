using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using WebApiCineStar.Models;
using System.Data;

namespace CineStarWeb.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ApiController : ControllerBase
    {
        private readonly string _con;

        public ApiController(IConfiguration config)
        {
            _con = config.GetConnectionString("DefaultConnection")
                ?? throw new InvalidOperationException("No se encontró cadena de conexión");
        }

        [HttpGet("peliculas/{id}")]
        public ActionResult<List<Pelicula>> GetPeliculas(int id)
        {
            var list = new List<Pelicula>();
            using var cn = new SqlConnection(_con);
            cn.Open();

            using (var cmd = new SqlCommand("sp_getPeliculas", cn) { CommandType = CommandType.StoredProcedure })
            {
                cmd.Parameters.AddWithValue("@idEstado", id);
                using var dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new Pelicula
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        Titulo = dr["Titulo"].ToString() ?? "",
                        Link = dr["Link"].ToString() ?? "",
                        Sinopsis = dr["Sinopsis"].ToString() ?? ""
                    });
                }
            }
            return Ok(list);
        }

        [HttpGet("pelicula/{id}")]
        public ActionResult<Pelicula> GetPelicula(int id)
        {
            var pelicula = new Pelicula();
            using var cn = new SqlConnection(_con);
            cn.Open();

            using (var cmd = new SqlCommand("sp_getPelicula", cn) { CommandType = CommandType.StoredProcedure })
            {
                cmd.Parameters.AddWithValue("@id", id);
                using var dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    pelicula.Id = Convert.ToInt32(dr["Id"]);
                    pelicula.Titulo = dr["Titulo"].ToString() ?? "";
                    pelicula.FechaEstreno = dr["FechaEstreno"].ToString() ?? "";
                    pelicula.Director = dr["Director"].ToString() ?? "";
                    pelicula.GenerosTexto = dr["Generos"].ToString() ?? "";
                    pelicula.Duracion = dr["Duracion"].ToString() ?? "";
                    pelicula.Link = dr["Link"].ToString() ?? "";
                    pelicula.Reparto = dr["Reparto"].ToString() ?? "";
                    pelicula.Sinopsis = dr["Sinopsis"].ToString() ?? "";
                }
                else return NotFound();
            }
            return Ok(pelicula);
        }

        [HttpGet("cines")]
        public ActionResult<List<Cine>> GetCines()
        {
            var list = new List<Cine>();
            using var cn = new SqlConnection(_con);
            cn.Open();

            using (var cmd = new SqlCommand("sp_getCines", cn) { CommandType = CommandType.StoredProcedure })
            {
                using var dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new Cine
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        RazonSocial = dr["RazonSocial"].ToString() ?? "",
                        Salas = Convert.ToInt32(dr["Salas"]),
                        DistritoNombre = dr["Detalle"].ToString() ?? "",
                        Direccion = dr["Direccion"].ToString() ?? "",
                        Telefonos = dr["Telefonos"].ToString() ?? ""
                    });
                }
            }
            return Ok(list);
        }

        [HttpGet("cine/{id}")]
        public ActionResult<CineViewModel> GetCine(int id)
        {
            var model = new CineViewModel();
            using var cn = new SqlConnection(_con);
            cn.Open();

            using (var cmd = new SqlCommand("sp_getCine", cn) { CommandType = CommandType.StoredProcedure })
            {
                cmd.Parameters.AddWithValue("@id", id);
                using var dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    model.CineDetalle = new Cine
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        RazonSocial = dr["RazonSocial"].ToString() ?? "",
                        Salas = Convert.ToInt32(dr["Salas"]),
                        DistritoNombre = dr["Detalle"].ToString() ?? "",
                        Direccion = dr["Direccion"].ToString() ?? "",
                        Telefonos = dr["Telefonos"].ToString() ?? ""
                    };
                }
                else return NotFound();
            }

            using (var cmd = new SqlCommand("sp_getCinePeliculas", cn) { CommandType = CommandType.StoredProcedure })
            {
                cmd.Parameters.AddWithValue("@idCine", id);
                using var dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    model.Horarios.Add(new CinePelicula
                    {
                        TituloPelicula = dr["Titulo"].ToString() ?? "",
                        Horarios = dr["Horarios"].ToString() ?? ""
                    });
                }
            }

            using (var cmd = new SqlCommand("sp_getCineTarifas", cn) { CommandType = CommandType.StoredProcedure })
            {
                cmd.Parameters.AddWithValue("@idCine", id);
                using var dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    string precioTexto = (dr["Precio"].ToString() ?? "0").Replace("S/.", "").Trim();
                    model.Tarifas.Add(new CineTarifa
                    {
                        DiasSemana = dr["DiasSemana"].ToString() ?? "",
                        Precio = decimal.TryParse(precioTexto, out decimal p) ? p : 0
                    });
                }
            }
            return Ok(model);
        }
    }
}
