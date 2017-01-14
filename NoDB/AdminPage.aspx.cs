using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NoDB
{
    public partial class AdminPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var uporabniki = new List<string>();

            var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var conn = new SqlConnection(connectionString);
            conn.Open();
            var cmd = new SqlCommand("SELECT username from Uporabnik;", conn);
            var r = cmd.ExecuteReader();

            if (!r.HasRows) return;
            while (r.Read())
            {
                uporabniki.Add(r.GetString(0));
            }
            conn.Close();

            foreach (var user in uporabniki)
            {
                Test.Items.Add(user);
            }
            

        }

        protected void DeleteUser_Click(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }

        protected void SetAdmin_Click(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }

        protected void LogoutAdmin_Click(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }
    }
}