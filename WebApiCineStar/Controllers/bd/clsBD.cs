using System;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace WebApiCineStar.Controllers.bd
{
    public class clsBD
    {
        private SqlConnection? cn = null;
        private SqlCommand? cmd = null;
        private SqlDataAdapter? da = null;

        public clsBD(string connectionName)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            
            var configuration = builder.Build();
            string connectionString = configuration.GetConnectionString("DefaultConnection") ?? "";
            
            cn = new SqlConnection(connectionString);
        }

        public void Sentencia(string sp)
        {
            if (cn != null)
            {
                cmd = new SqlCommand(sp, cn);
                cmd.CommandType = CommandType.StoredProcedure;
            }
        }

        public void Parametro(string parameterName, object parameterValue)
        {
            if (cmd != null)
            {
                cmd.Parameters.AddWithValue(parameterName, parameterValue);
            }
        }

        public DataTable getDataTable()
        {
            DataTable dt = new DataTable();
            if (cmd != null)
            {
                da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return dt;
        }
    }
}
