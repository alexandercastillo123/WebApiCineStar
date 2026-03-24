using System.Collections.Generic;

namespace ConsumirApiCineStarWeb.Models
{
    public class Cine
    {
        public int Id { get; set; }
        public string RazonSocial { get; set; } = string.Empty;
        public int Salas { get; set; }
        public int IdDistrito { get; set; }
        public string DistritoNombre { get; set; } = string.Empty;
        public string Direccion { get; set; } = string.Empty;
        public string Telefonos { get; set; } = string.Empty;

        public List<CineTarifa> Tarifas { get; set; } = new List<CineTarifa>();
        public List<CinePelicula> Horarios { get; set; } = new List<CinePelicula>();
    }

    public class CineTarifa
    {
        public int IdCine { get; set; }
        public string DiasSemana { get; set; } = string.Empty;
        public string Precio { get; set; } = string.Empty;
    }

    public class CinePelicula
    {
        public int IdCine { get; set; }
        public int IdPelicula { get; set; }
        public int Sala { get; set; }
        public string Horarios { get; set; } = string.Empty;
        public string TituloPelicula { get; set; } = string.Empty;
    }
}