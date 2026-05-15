using System;
using System.Data;
using Npgsql;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace WebApiCineStar.Controllers.bd
{
    public class clsBD
    {
        private NpgsqlConnection? cn = null;
        private NpgsqlCommand? cmd = null;
        private NpgsqlDataAdapter? da = null;

        public clsBD(string connectionName)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            
            var configuration = builder.Build();
            string connectionString = configuration.GetConnectionString("DefaultConnection") ?? "";
            
            cn = new NpgsqlConnection(connectionString);
        }

        public void Sentencia(string sp)
        {
            if (cn != null)
            {
                // En PostgreSQL, las funciones que retornan tablas se deben llamar con SELECT * FROM nombre_funcion(...)
                // Para simplificar, usaremos CommandType.Text y construiremos la llamada.
                cmd = new NpgsqlCommand("SELECT * FROM " + sp + "()", cn);
                cmd.CommandType = CommandType.Text;
            }
        }

        public void Parametro(string parameterName, object parameterValue)
        {
            if (cmd != null)
            {
                // PostgreSQL no usa @ para los parámetros en el cuerpo de la función, pero Npgsql sí lo soporta en el comando.
                // Sin embargo, para que funcione con SELECT * FROM sp(), debemos asegurar que el comando reconozca los argumentos.
                
                // Quitamos el @ si viene en el nombre para manejarlo uniformemente
                string cleanName = parameterName.StartsWith("@") ? parameterName.Substring(1) : parameterName;
                
                // Agregamos el parámetro a la colección
                cmd.Parameters.AddWithValue(cleanName, parameterValue);

                // Actualizamos el CommandText para incluir los parámetros en la llamada
                // Ejemplo: cambia "SELECT * FROM sp()" a "SELECT * FROM sp(p1 => @p1, p2 => @p2)"
                string paramRef = cleanName + " := @" + cleanName;
                if (cmd.CommandText.EndsWith("()"))
                {
                    cmd.CommandText = cmd.CommandText.Replace("()", "(" + paramRef + ")");
                }
                else
                {
                    cmd.CommandText = cmd.CommandText.Replace(")", ", " + paramRef + ")");
                }
            }
        }

        public DataTable getDataTable()
        {
            DataTable dt = new DataTable();
            if (cmd != null)
            {
                da = new NpgsqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return dt;
        }
    }
}
