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

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


class LoginResponse {
    private boolean isAuth;
    public boolean getAuth(){
        return this.isAuth;
    }
    public void setAuth(boolean newAuth){
        this.isAuth = newAuth;
    }
}
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
            }
        });

    }

    public class CallAPI extends AsyncTask<String, String, String> {
        final Context ctx = getApplicationContext();
        public CallAPI() {}
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected String doInBackground(String... params) {
            LoginRequest req = new LoginRequest();
            req.setUsername(params[0]);
            req.setPassword(params[1]);
            httpHandler hh = new httpHandler(req.getUsername(), req.getPassword());
            return hh.makeServiceCall(req.toString());
        }
        @Override
        protected void onPostExecute(String result) {
            try {
                JSONObject msg = new JSONObject(result);
                if(msg.getBoolean("isAuth")){
                    Intent i = new Intent();
                    EditText usr_et = (EditText) findViewById(R.id.editText3);
                    EditText pwd_et = (EditText) findViewById(R.id.editText4);
                    String username = usr_et.getText().toString();
                    String password = pwd_et.getText().toString();
                    i.putExtra("usr", username);
                    i.putExtra("pwd", password);
                    startActivity(i);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }
}