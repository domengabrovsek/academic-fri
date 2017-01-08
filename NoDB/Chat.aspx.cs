using System;
using System.Collections;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

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
            if (!IsPostBack)
            {
                // set currentUser label
                CurrentUser.Text = "Prijavljeni ste kot: " + Session["currentUser"].ToString();

                // if no users, create history and onlineUsers arrayList
                if (Application["onlineUsers"] == null)
                {
                    Application["onlineUsers"] = new ArrayList();
                    Application["history"] = new ArrayList();

                }

                refreshHistory();

                // add current user to onlineUsers
                ArrayList tmp = (ArrayList)Application["onlineUsers"];
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
        }

        protected void Logout_Click(object sender, EventArgs e)
        {
            removeUser();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void Send_Click(object sender, EventArgs e)
        {
            // insert message(username = Session["currentUser], sporocilo = Message.Value into [chatdb].[Pogovor]
            try
            {
                string query = "INSERT INTO Pogovor VALUES (" + "'" + Session["currentUser"] + "'" + "," + "'" + Message.Value + "'" + ")";
                string connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

                SqlConnection sqlConnection1 = new SqlConnection(connectionString);

                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = query;
                cmd.Connection = sqlConnection1;

                sqlConnection1.Open();
                cmd.ExecuteNonQuery();
                sqlConnection1.Close();

            }

            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            // assemble message (user : message)
            string message = Session["currentUser"] + " : " + Message.Value;

            Messages.Items.Add(message);
            Message.Value = null;
            refreshUsers();
            refreshHistory();
            Message.Focus();

        }

        protected void Refresh_Click(object sender, EventArgs e)
        {
            refreshUsers();
            refreshHistory();
        }

        // refresh history
        protected void refreshHistory()
        {

            Messages.Items.Clear();
            String connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT username, besedilo from Pogovor;", conn);
            SqlDataReader r = cmd.ExecuteReader();

            if (r.HasRows)
            {
                while (r.Read())
                {
                    //TODO
                    //tuki dostopaš do baze, "{0}:{1}", reader.GetString(0), reader.GetString(1) je format za "username:besedilo"
                    string message = r.GetString(0) + " : " + r.GetString(1);
                    Messages.Items.Add(message);
                }
            }
        }

        // refresh online users
        protected void refreshUsers()
        {
            ArrayList tmp = (ArrayList)Application["onlineUsers"];
            Users.Items.Clear();
            foreach (var item in tmp)
            {
                Users.Items.Add(item.ToString());
            }
        }
        // remove user on logout
        protected void removeUser()
        {
            ArrayList tmp = (ArrayList)Application["onlineUsers"];
            tmp.Remove(Session["currentUser"]);
            Application["onlineUsers"] = tmp;
        }
    }
}