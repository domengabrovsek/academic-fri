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
            wrongPassword1.Text = "";
            wrongPassword2.Text = "";
        }

        protected string calculateMD5(string input)

        {

            // step 1, calculate MD5 hash from input

            MD5 md5 = System.Security.Cryptography.MD5.Create();

            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);

            byte[] hash = md5.ComputeHash(inputBytes);

            // step 2, convert byte array to hex string

            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < hash.Length; i++)

            {

                sb.Append(hash[i].ToString("X2"));

            }

            return sb.ToString();

        }

        // count number of numbers in a string
        protected int countNumbersInString(string password)
        {
            char[] numbers = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };
            char[] letters = password.ToCharArray();

            int numbersCount = 0;

            for (int i = 0; i < password.Length; i++)
            {
                if (password[i].ToString().IndexOfAny(numbers) != -1)
                {
                    numbersCount += 1;
                }
            }

            return numbersCount;
        }

        // count number of uppercase letters in a string
        protected int countUpperCaseLetters(string password)
        {
            int upperCaseLettersCount = 0;
            char[] letters = password.ToCharArray();

            for (int i = 0; i < letters.Length; i++)
            {
                if (Char.IsUpper(password[i]))
                {
                    upperCaseLettersCount += 1;
                }
            }

            return upperCaseLettersCount;
        }

        // check if password satisfies the criteria
        protected bool checkPasswordRegistration()
        {
            char[] specialCharacters = { '?', '.', '!', '*', ':' };
            string username, name, surname, password, repeatPassword;

            username = Username.Value;
            name = Name.Value;
            surname = Surname.Value;
            password = Password.Value;
            repeatPassword = PasswordRepeat.Value;

            int numbersInString = countNumbersInString(password);
            int uppercaseLettersInString = countUpperCaseLetters(password);

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

        protected string checkCredentialsLogin()
        {
            string username, password, query, md5Pass;
            bool exists = false;

            username = LoginUsername.Value;
            password = LoginPassword.Value;
            md5Pass = calculateMD5(password);
            query = "SELECT Count(username) as cnt FROM Uporabnik WHERE username=" + "'" + username + "'" + " AND geslo=" + "'" + md5Pass + "'";
            LoginUsername.Value = query;
            // check if user exists in database       

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;


                SqlConnection sqlConnection1 = new SqlConnection(connectionString);

                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = query;
                cmd.Connection = sqlConnection1;

                sqlConnection1.Open();
                cmd.ExecuteNonQuery();

                SqlDataReader r = cmd.ExecuteReader();
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
            if (exists)
            {
                return username;
            }
            // else return empty string
            else
            {
                return "";
            }

            
        }

        protected void RegistrationBtn_Click(object sender, EventArgs e)
        {

            string username, name, surname, password, md5Pass, query;

            username = Username.Value;
            name = Name.Value;
            surname = Surname.Value;
            password = Password.Value;
            md5Pass = calculateMD5(password);

            bool jeRegistriran = false;
            

            // if password meets all conditions insert user to database
            if (checkPasswordRegistration())
            {
                //insert user to database (password has to be MD5)
                try
                {
                    string connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

                    query = "INSERT INTO Uporabnik(username, ime, priimek, geslo) VALUES(" + "'" + username + "'" + "," +
                                                                                           "'" + name + "'" + "," +
                                                                                           "'" + surname + "'" + "," +
                                                                                           "'" + md5Pass + "'" + ")";
                    SqlConnection sqlConnection1 = new SqlConnection(connectionString);

                    SqlCommand cmd = new SqlCommand();
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = query;
                    cmd.Connection = sqlConnection1;

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
            string username = checkCredentialsLogin();

            // ce je veljaven uporabnik
            if (!username.Equals(""))
            {
                Session["currentUser"] = username;
                Response.Redirect("Chat.aspx");
            }

            // ce uporabnik ne obstaja ali napacno geslo
            else
            {
                
               // Response.Redirect("Login.aspx");
                Username.Value = "no worke";
            }

        }
    }
}