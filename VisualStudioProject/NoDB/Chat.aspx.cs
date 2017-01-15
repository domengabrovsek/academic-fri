using System;
using System.Collections;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using static System.String;

namespace NoDB
{

    public partial class Login : System.Web.UI.Page
    {
        // page load
        protected void Page_Load(object sender, EventArgs e)
        {
            // if user isn't logged in send him back to login screen
            if (Session["currentUser"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            // only on first visit to the page
            if (IsPostBack) return;

            // set currentUser label
            CurrentUser.Text = "Prijavljeni ste kot: " + Session["currentUser"];


            // if no users, create history and onlineUsers arrayList
            if (Application != null && Application["onlineUsers"] == null)
            {
                Application["onlineUsers"] = new ArrayList();
                Application["history"] = new ArrayList();

            }

            RefreshHistory();

            // add current user to onlineUsers
            var tmp = (ArrayList)Application["onlineUsers"];
            if (!(tmp.Contains(Session["currentUser"])))
            {
                tmp.Add(Session["currentUser"]);
            }
                
            Application["onlineUsers"] = tmp;

            foreach (var item in tmp)
            {
                // onlineUsers is a listbox control
                Users.Items.Add(item.ToString());
            }
        }

        // logout click
        protected void Logout_Click(object sender, EventArgs e)
        {
            RemoveUser();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        // send click
        protected void Send_Click(object sender, EventArgs e)
        {
            // insert message(username = Session["currentUser], sporocilo = Message.Value into [chatdb].[Pogovor]
            try
            {
                var query = Format("INSERT INTO Pogovor VALUES ('{0}', '{1}', '{2}');", Session["currentUser"], Message.Value, DateTime.Now);
                var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

                var sqlConnection1 = new SqlConnection(connectionString);

                var cmd = new SqlCommand
                {
                    CommandType = CommandType.Text,
                    CommandText = query,
                    Connection = sqlConnection1
                };

                sqlConnection1.Open();
                cmd.ExecuteNonQuery();
                sqlConnection1.Close();

            }

            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            // assemble message (user : message)
            var message = Session["currentUser"] + " : " + Message.Value;

            Messages.Items.Add(message);
            Message.Value = null;
            RefreshUsers();
            RefreshHistory();
            Message.Focus();

        }

        // refresh click
        protected void Refresh_Click(object sender, EventArgs e)
        {
            RefreshUsers();
            RefreshHistory();
        }

        // refresh history
        protected void RefreshHistory()
        {

            Messages.Items.Clear();
            var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var conn = new SqlConnection(connectionString);
            conn.Open();
            var cmd = new SqlCommand("SELECT username, besedilo from Pogovor;", conn);
            var r = cmd.ExecuteReader();

            if (!r.HasRows) return;
            while (r.Read())
            {
                //TODO
                //tuki dostopaš do baze, "{0}:{1}", reader.GetString(0), reader.GetString(1) je format za "username:besedilo"
                var message = r.GetString(0) + " : " + r.GetString(1);
                Messages.Items.Add(message);
            }
        }

        // refresh online users
        protected void RefreshUsers()
        {
            var tmp = (ArrayList)Application["onlineUsers"];
            Users.Items.Clear();
            foreach (var item in tmp)
            {
                Users.Items.Add(item.ToString());
            }
        }
       
        // remove user on logout
        protected void RemoveUser()
        {
            var tmp = (ArrayList)Application["onlineUsers"];
            tmp.Remove(Session["currentUser"]);
            Application["onlineUsers"] = tmp;
        }
    }
}