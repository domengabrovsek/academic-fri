using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Configuration;

namespace NoDB
{
   

    public partial class Chat : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            var isAdmin = false;
            wrongPassword1.Text = "";
            wrongPassword2.Text = "";
        }

        // calculate md5 hash
        protected string CalculateMd5(string input)
        {
            // step 1, calculate MD5 hash from input
            var md5 = MD5.Create();
            var inputBytes = Encoding.ASCII.GetBytes(input);
            var hash = md5.ComputeHash(inputBytes);

            // step 2, convert byte array to hex string
            var sb = new StringBuilder();

            foreach (var t in hash)
            {
                sb.Append(t.ToString("X2"));
            }

            return sb.ToString();
        }

        // count number of numbers in a string
        protected int CountNumbersInString(string password)
        {
            char[] numbers = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };

            var numbersCount = 0;

            foreach (var t in password)
            {
                if (t.ToString().IndexOfAny(numbers) != -1)
                {
                    numbersCount += 1;
                }
            }

            return numbersCount;
        }

        // count number of uppercase letters in a string
        protected int CountUpperCaseLetters(string password)
        {
            var upperCaseLettersCount = 0;
            var letters = password.ToCharArray();

            for (var i = 0; i < letters.Length; i++)
            {
                if (char.IsUpper(password[i]))
                {
                    upperCaseLettersCount += 1;
                }
            }

            return upperCaseLettersCount;
        }

        // check if password satisfies the criteria
        protected bool CheckPasswordRegistration()
        {
            char[] specialCharacters = { '?', '.', '!', '*', ':' };

            var password = Password.Value;
            var repeatPassword = PasswordRepeat.Value;

            var numbersInString = CountNumbersInString(password);
            var uppercaseLettersInString = CountUpperCaseLetters(password);

            // if passwords dont match
            if (!password.Equals(repeatPassword))
            {
                // print out warning message
                wrongPassword1.Text = "Gesli se ne ujemata!";
                wrongPassword2.Text = "Gesli se ne ujemata!";
                return false;
            }

            // if passwords match 
            else
            {
                // if upperCaseLetters >= 2, if specialChar >= 1, if numbers >= 2, if length >= 8
                if (password.IndexOfAny(specialCharacters) != -1 &&
                                            password.Length >= 8 &&
                                            numbersInString >= 2 &&
                                            uppercaseLettersInString >= 2)
                {
                    return true;
                }


            }

            return false;
        }

        // check credentials for login
        protected string CheckCredentialsLogin()
        {
            var exists = false;
            var username = LoginUsername.Value;
            var password = LoginPassword.Value;
            var md5Pass = CalculateMd5(password);
            var query = "SELECT Count(username) as cnt FROM Uporabnik WHERE username=" + "'" + username + "'" + " AND geslo=" + "'" + md5Pass + "'";
            LoginUsername.Value = query;

            // check if user exists in database       
            try
            {
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

                var r = cmd.ExecuteReader();
                r.Read();
                if(r.GetInt32(0) >= 1)
                {
                    exists = true;
                }
                sqlConnection1.Close();


                }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            // if user exists in database and password is correct allow login
            return exists ? username : "";
    
        }

        protected void RegistrationBtn_Click(object sender, EventArgs e)
        {
            var username = Username.Value;
            var name = Name.Value;
            var surname = Surname.Value;
            var password = Password.Value;
            var md5Pass = CalculateMd5(password);

            // if password meets all conditions insert user to database
            if (CheckPasswordRegistration())
            {
                //insert user to database (password has to be MD5)
                try
                {
                    var connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                    var query = "INSERT INTO Uporabnik(username, ime, priimek, geslo) VALUES(" + "'" + username + "'" + "," +
                                   "'" + name + "'" + "," +
                                   "'" + surname + "'" + "," +
                                   "'" + md5Pass + "'" + ")";
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

                    RegistrationSuccess.Text = "Vaš uporabniški račun je bil uspešno ustvarjen!";
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }

            // geslo mora vsebovati vsaj 2 veliki črki, vsaj 1 poseben znak (?.* !:), vsaj dve števki in mora biti dolgo najmanj 8 znakov.
            else
            {
                wrongPassword1.Text = "geslo mora vsebovati vsaj 2 veliki črki, vsaj 1 poseben znak (?.* !:), vsaj dve števki in mora biti dolgo najmanj 8 znakov.";
                // warning message or something
            }

        }

        protected void LoginBtn_Click(object sender, EventArgs e)
        {
            var username = CheckCredentialsLogin();

            // ce ni veljaven uporabnik
            if (username.Equals("")) Response.Redirect("Login.aspx");

            Session["currentUser"] = username;
            Response.Redirect("Chat.aspx");
            
        }

        protected void AdminLoginBtn_OnClick(object sender, EventArgs e)
        {
            var username = CheckCredentialsLogin();

            if (!username.Equals(""))
            {
                Session["currentUser"] = username;
                Response.Redirect("AdminPage.aspx");
            }
        }
    }
}