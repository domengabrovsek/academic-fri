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

            /*
            if (Session["currentUser"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            */
            if (IsPostBack)
            {

                if (!Uporabniki.SelectedValue.Contains("Izberi"))
                {
                    izbraniUporabnik.Text = String.Format("Izbrani uporabnik: {0}", Uporabniki.SelectedValue);
                    stSporocil.Text = Format("Stevilo sporocil: {0}", GetNumOfMessages(Uporabniki.SelectedValue));
                }           
            }

            // clear listview because we don't want duplicates
            Uporabniki.Items.Clear();
            SelectUser("", 2);
            if (!Uporabniki.SelectedValue.Contains("Izberi"))
            {
                stSporocil.Text = Format("Stevilo sporocil: {0}", GetNumOfMessages(Uporabniki.SelectedValue));
            }
            
        }

        // select user or users from database
        protected string SelectUser(string user, int option)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var conn = new SqlConnection(connectionString);
            conn.Open();

            // 1 = select one user
            if (option == 1)
            {
                var cmd = new SqlCommand(String.Format("SELECT username FROM Uporabnik WHERE username = '{0}';", user), conn);
                var r = cmd.ExecuteReader();
                conn.Close();
                return r.GetString(0);
            }
            
            // 2 = select all users and fill Uporabnik ListView
            else if (option == 2)
            {
                var uporabniki = new List<string>(); uporabniki.Add("-- Izberi uporabnika --");
                
                var cmd = new SqlCommand("SELECT username from Uporabnik;", conn);
                var r = cmd.ExecuteReader();

                if (!r.HasRows) return null;
                while (r.Read())
                {
                    uporabniki.Add(r.GetString(0));
                }
                conn.Close();

                foreach (var uporabnik in uporabniki)
                {
                    Uporabniki.Items.Add(uporabnik);
                }
            }

            return null;
        }

        // delete user from database
        protected void DeleteUser(string user)
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

        // set user as admin
        protected void SetAdmin(string user)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var conn = new SqlConnection(connectionString);
            conn.Open();
            var cmd = new SqlCommand(String.Format("SELECT username FROM Uporabnik WHERE username = '{0}';", user), conn);
            var r = cmd.ExecuteReader();
            conn.Close();
        }

        // get number of messager for user
        protected int GetNumOfMessages(string user)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var conn = new SqlConnection(connectionString);
            conn.Open();

            // delete all conversations from selected user from database
            var query = Format("SELECT COUNT(besedilo) as n FROM Pogovor WHERE username = '{0}';", user);
            var cmd = new SqlCommand(query, conn);
            var r = cmd.ExecuteReader();


            if (r.Read())
            {
                var stSporocil = r.GetInt32(0);
                conn.Close();
                return stSporocil;
            }

            conn.Close();
            return 0;
        }

        protected void DeleteUser_Click(object sender, EventArgs e)
        {
            var selectedUser = Uporabniki.SelectedValue;
            DeleteUser(selectedUser);
        }

        protected void LogoutAdmin_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void MakeAdmin_Click(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }
    }
}