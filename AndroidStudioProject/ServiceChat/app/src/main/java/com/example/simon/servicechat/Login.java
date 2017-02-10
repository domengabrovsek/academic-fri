package com.example.simon.servicechat;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import org.json.JSONObject;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

class LoginRequest {
    private String Username;
    private String Password;
    public String getUsername(){
        return this.Username;
    }
    public void setUsername(String newUsername){
        this.Username = newUsername;
    }
    public String getPassword(){
        return this.Password;
    }
    public void setPassword(String newPassword){
        this.Password = newPassword;
    }
    public JSONObject toJson(){
        JSONObject temp = new JSONObject();
        try{
            temp.put("Username", this.Username);
            temp.put("Password", this.Password);
        }catch (Exception e){
            e.printStackTrace();
        }
        return temp;
    }
}
public class Login extends AppCompatActivity {
    boolean isAuth;
    String usr;
    String pwd;
    void loginClicked(Boolean isAuth){
        if(isAuth){
            EditText usr_et = (EditText) findViewById(R.id.editText3);
            EditText pwd_et = (EditText) findViewById(R.id.editText4);
            this.usr = usr_et.getText().toString();
            this.pwd = pwd_et.getText().toString();
            Intent i = new Intent(this, chat.class);
            i.putExtra("usr", this.usr);
            i.putExtra("pwd", this.pwd);
            startActivity(i);
        }
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        final Context ctx = getApplicationContext();
        Button login_btn = (Button) findViewById(R.id.button);
        login_btn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                EditText usr_et = (EditText) findViewById(R.id.editText3);
                EditText pwd_et = (EditText) findViewById(R.id.editText4);
                String username = usr_et.getText().toString();
                String password = pwd_et.getText().toString();
                TextView wrong_pw = (TextView) findViewById(R.id.textView4);
                String[] params = {username, password};
                CallAPI call = new CallAPI();
                call.execute(params);
            }
        });

    }

    public class CallAPI extends AsyncTask<String, String, Integer> {
        final Context ctx = getApplicationContext();
        public CallAPI() {}
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected Integer doInBackground(String... params) {
            LoginRequest req = new LoginRequest();
            req.setUsername(params[0]);
            req.setPassword(params[1]);
            Integer status = 0;
            HttpURLConnection conn = null;
            try {
                URL url = new URL("http://chatton.azurewebsites.net/api/user/Androidlogin");
                conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json");
                conn.setRequestProperty("Accept", "application/json");
                conn.setDoOutput(true);
                conn.setChunkedStreamingMode(0);
                conn.setDoInput(true);
                conn.connect();

                OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
                wr.write(req.toJson().toString());
                wr.flush();
                status = conn.getResponseCode();
            }catch (Exception e) {
                e.printStackTrace();
            }

            return status;
        }
        @Override
        protected void onPostExecute(Integer result) {
            try {
                if(result == 200) loginClicked(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}