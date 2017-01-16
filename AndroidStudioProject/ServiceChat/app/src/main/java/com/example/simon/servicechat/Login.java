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

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;


public class Login extends AppCompatActivity {
    private static String url = "http://servicechat3.somee.com/Service1.svc/Login/";
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
                Intent i = new Intent(ctx, chat.class);
                i.putExtra("usr", username);
                i.putExtra("pwd", password);
                String[] params = {url, username, password};
                grabber g = new grabber(username, password);
                g.callService(url, params);
            }
        });

    }

    public class CallAPI extends AsyncTask<String, String, String> {

        public CallAPI() {
            //set context variables if required
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }


        @Override
        protected String doInBackground(String... params) {

            String urlString = params[0]; // URL to call
            System.out.println(urlString);
            String resultToDisplay = "";

            InputStream in = null;
            try {

                URL url = new URL(urlString);

                HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();

                in = new BufferedInputStream(urlConnection.getInputStream());


            } catch (Exception e) {

                System.out.println(e.getMessage());

                return e.getMessage();

            }

            try {
                byte[] contents = new byte[1024];

                int bytesRead = 0;
                String strFileContents = "";
                while ((bytesRead = in.read(contents)) != -1) {
                    strFileContents += new String(contents, 0, bytesRead);
                }
                //to [convert][1] byte stream to a string
            } catch (IOException e) {
                e.printStackTrace();
            }
            System.out.println(resultToDisplay);
            return resultToDisplay;
        }


        @Override
        protected void onPostExecute(String result) {
            //Update the UI
        }
    }

    private class authUser extends AsyncTask<String, String, String> {
        @Override
        protected void onPreExecute() {

        }

        @Override
        protected String doInBackground(String... params) {
            if (params.length == 2) {
                grabber g = new grabber(params[0], params[1]);
                String result = g.callService(url, params);
                return result;
            }

            return null;
        }

        @Override
        protected void onPostExecute(String result) {
            TextView wrong_pw = (TextView) findViewById(R.id.textView4);
            wrong_pw.setText(result);
        }
    }
}