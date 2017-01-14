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
using static System.String;

namespace NoDB
{
    public partial class AdminPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (IsPostBack) return;
            var uporabniki = new List<string>();

            // clear listview because we don't want duplicates
            Uporabniki.Items.Clear();
            
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
                Uporabniki.Items.Add(user);
            }

        }

        protected void deleteUser(string user)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var conn = new SqlConnection(connectionString);
            conn.Open();

            // delete all conversations from selected user from database
            var query = Format("DELETE FROM Pogovor WHERE username = '{0}';", user);
            var cmd = new SqlCommand(query, conn);
            var r = cmd.ExecuteReader();
            r.Close();

            // delete selected user from database
            query = Format("DELETE FROM Uporabnik WHERE username = '{0}';", user);
            cmd = new SqlCommand(query, conn);
            cmd.ExecuteReader();
            
            conn.Close();
        }

        protected void DeleteUser_Click(object sender, EventArgs e)
        {
            var selectedUser = Uporabniki.SelectedValue;
            deleteUser(selectedUser);
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