using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
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
                // ce je ne prvem mestu dropdowna --Izberi uporabnika-- nočemo brati iz baze ker to ni dejanski uporabnik
                if (!Uporabniki.SelectedValue.Contains("Izberi"))
                {
                    Application["selectedUser"] = Uporabniki.SelectedValue;
                    var user = Application["selectedUser"].ToString();
                    izbraniUporabnik.Text = String.Format("Izbrani uporabnik: {0}", user);
                    stSporocil.Text = Format("Stevilo sporocil: {0}", GetNumOfMessages(user));
                    isAdmin.Text = Format("Je administrator: {0}", CheckIfAdmin(user) ? "Da" : "Ne");
                    // ce je uporabnik administrator na gumbu pise uporabnik in obratno
                    makeAdmin.Text = CheckIfAdmin(user) ? "Uporabnik" : "Administrator";
                }           
            }

            // clear listview because we don't want duplicates
            Uporabniki.Items.Clear();
            SelectUser("", 2);
           
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

        // set / unset user as admin
        protected void SetAdmin(string user, bool isAdmin)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var conn = new SqlConnection(connectionString);
            conn.Open();

            var cmd = new SqlCommand(Format("UPDATE Uporabnik SET isadmin = {0} WHERE username = '{1}';", isAdmin ? 0 : 1, user), conn);
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

        // check if user is administrator
        protected bool CheckIfAdmin(string user)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var conn = new SqlConnection(connectionString);
            var query = Format("SELECT isadmin FROM Uporabnik WHERE username = '{0}';", user);
            var cmd = new SqlCommand
            {
                CommandType = CommandType.Text,
                CommandText = query,
                Connection = conn
            };

            conn.Open();
            cmd.ExecuteNonQuery();

            var r = cmd.ExecuteReader();
            r.Read();
            var admin = r.GetBoolean(0);

            conn.Close();
            return admin;
        }


        protected void DeleteUser_Click(object sender, EventArgs e)
        {
            var selectedUser = Application["selectedUser"].ToString();
            DeleteUser(selectedUser);
        }

        protected void LogoutAdmin_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void makeAdmin_Click(object sender, EventArgs e)
        {
            var user = Application["selectedUser"].ToString();
            var admin = CheckIfAdmin(user);

            SetAdmin(user, admin);
            izbraniUporabnik.Text = String.Format("Izbrani uporabnik: {0}", user);
            stSporocil.Text = Format("Stevilo sporocil: {0}", GetNumOfMessages(user));
            isAdmin.Text = Format("Je administrator: {0}", CheckIfAdmin(user) ? "Da" : "Ne");
            // ce je uporabnik administrator na gumbu pise uporabnik in obratno
            makeAdmin.Text = CheckIfAdmin(user) ? "Uporabnik" : "Administrator";
        }
    }
}