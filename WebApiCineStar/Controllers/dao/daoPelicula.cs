using WebApiCineStar.Controllers.bd;
using WebApiCineStar.Models;
using System.Collections.Generic;

namespace WebApiCineStar.Controllers.dao
{
    public class daoPelicula
    {
        bd.clsBD clsBD = new bd.clsBD("CineStar");

        internal Pelicula? getPelicula(int id)
        {
            clsBD.Sentencia("sp_getPelicula");
            clsBD.Parametro("@id", id);
            return new Pelicula().getRegistro(clsBD.getDataTable());
        }

        internal List<Pelicula> getPeliculas(int id)
        {
            clsBD.Sentencia("sp_getPeliculas");
            clsBD.Parametro("@idEstado", id);
            return new Pelicula().getList(clsBD.getDataTable());
        }
    }
}
