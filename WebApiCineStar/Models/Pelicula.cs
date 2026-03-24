using System;
using System.Collections.Generic;
using System.Data;

namespace WebApiCineStar.Models
{
    public class Pelicula
    {
        public int Id { get; set; }
        public string Titulo { get; set; } = string.Empty;
        public string FechaEstreno { get; set; } = string.Empty;
        public string Director { get; set; } = string.Empty;
        public string Generos { get; set; } = string.Empty;
        public int IdClasificacion { get; set; }
        public string Clasificacion { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public string Duracion { get; set; } = string.Empty;
        public string Link { get; set; } = string.Empty;
        public string Reparto { get; set; } = string.Empty;
        public string Sinopsis { get; set; } = string.Empty;

        public List<Pelicula> getList(DataTable dt)
        {
            List<Pelicula> peliculas = new List<Pelicula>();
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    peliculas.Add(new Pelicula
                    {
                        Id = Convert.ToInt32(dr["id"]),
                        Titulo = dr["Titulo"].ToString() ?? "",
                        Sinopsis = dr["Sinopsis"].ToString() ?? "",
                        Link = dr["Link"].ToString() ?? ""
                    });
                }
            }
            return peliculas;
        }

        public Pelicula? getRegistro(DataTable dt)
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];
                return new Pelicula
                {
                    Id = dt.Columns.Contains("id") ? Convert.ToInt32(dr["id"]) : 0,
                    Titulo = dt.Columns.Contains("Titulo") ? dr["Titulo"].ToString() ?? "" : "",
                    FechaEstreno = dt.Columns.Contains("FechaEstreno") ? dr["FechaEstreno"].ToString() ?? "" : "",
                    Director = dt.Columns.Contains("Director") ? dr["Director"].ToString() ?? "" : "",
                    Generos = dt.Columns.Contains("Generos") ? dr["Generos"].ToString() ?? "" : "",
                    IdClasificacion = dt.Columns.Contains("idClasificacion") ? Convert.ToInt32(dr["idClasificacion"]) : 0,
                    Clasificacion = dt.Columns.Contains("Clasificacion") ? dr["Clasificacion"].ToString() ?? "" : "",
                    IdEstado = dt.Columns.Contains("idEstado") ? Convert.ToInt32(dr["idEstado"]) : 0,
                    Estado = dt.Columns.Contains("Estado") ? dr["Estado"].ToString() ?? "" : "",
                    Duracion = dt.Columns.Contains("Duracion") ? dr["Duracion"].ToString() ?? "" : "",
                    Link = dt.Columns.Contains("Link") ? dr["Link"].ToString() ?? "" : "",
                    Reparto = dt.Columns.Contains("Reparto") ? dr["Reparto"].ToString() ?? "" : "",
                    Sinopsis = dt.Columns.Contains("Sinopsis") ? dr["Sinopsis"].ToString() ?? "" : ""
                };
            }
            return null;
        }
    }
}