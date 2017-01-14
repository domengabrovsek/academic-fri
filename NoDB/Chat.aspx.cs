using System;
using System.Collections;
using System.ComponentModel.Design;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using NoDB.PlsWorke;

namespace NoDB
{

    public partial class Login : System.Web.UI.Page
    {
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
            var o = Session["currentUser"];
            if (o != null)
                CurrentUser.Text = "Prijavljeni ste kot: " + o;

            // test
            
            var service1 = new Service1();

            Message.Value = service1.VrniIme(1, true);

            // test


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

        public object WebReference1 { get; set; }

        protected void Logout_Click(object sender, EventArgs e)
        {
            RemoveUser();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void Send_Click(object sender, EventArgs e)
        {
            // insert message(username = Session["currentUser], sporocilo = Message.Value into [chatdb].[Pogovor]
            try
            {
                var query = "INSERT INTO Pogovor VALUES (" + "'" + Session["currentUser"] + "'" + "," + "'" + Message.Value + "'" + ")";
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