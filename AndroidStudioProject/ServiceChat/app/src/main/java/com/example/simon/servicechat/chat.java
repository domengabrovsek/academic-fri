package com.example.simon.servicechat;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

class messageRequest{
    String username;
    String text;
    public messageRequest(String usr, String txt){
        this.username = usr;
        this.text = txt;
    }
    public JSONObject toJson(){
        JSONObject temp = new JSONObject();
        try{
            temp.put("Username", this.username);
            temp.put("Text", this.text);
        }catch (Exception e){
            e.printStackTrace();
        }
        return temp;
    }
}

public class chat extends AppCompatActivity {
    private Intent i;
    private String usr;
    private String pwd;
    private void updateChat(String data){
        try{
            JSONArray json = new JSONArray(data);
            ScrollView scroll = (ScrollView) findViewById(R.id.scroll);
            LinearLayout ll = (LinearLayout) findViewById(R.id.asd);
            ll.removeAllViews();
            scroll.removeAllViews();
            for(int i = 0; i < json.length(); i++){
                JSONObject o = json.getJSONObject(i);
                TextView e = new TextView(this);
                e.setText(o.getString("username")+": "+o.getString("text"));
                ll.addView(e);
            }
            scroll.addView(ll);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    private class CallRefresh extends AsyncTask<String, String, String>{
        @Override
        protected String doInBackground(String... params){
            String response = "";
            InputStream in = null;
            HttpURLConnection conn = null;
            try{
                URL url = new URL("http://chatton.azurewebsites.net/api/Message/Android");
                conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Accept", "application/json");
                conn.connect();
                in = new BufferedInputStream(conn.getInputStream());
                response = convertStreamToString(in);
            }catch(Exception e){
                e.printStackTrace();
            }
            return response;
        }
        @Override
        protected void onPostExecute(String result){
            updateChat(result);
        }
        private String convertStreamToString(InputStream is) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            StringBuilder sb = new StringBuilder();

            String line;
            try {
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append('\n');
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return sb.toString();
        }
    }
    private class CallAPI extends AsyncTask<String, String, String>{
        final Context ctx = getApplicationContext();
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected String doInBackground(String... params) {
            String response = "";
            InputStream in = null;
            HttpURLConnection conn = null;
            try {
                URL url = new URL("http://chatton.azurewebsites.net/api/message/Send");
                conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json");
                conn.setRequestProperty("Accept", "application/json");
                conn.setChunkedStreamingMode(0);
                conn.setDoInput(true);
                conn.setDoOutput(true);
                conn.connect();
                messageRequest req = new messageRequest(params[0], params[1]);
                OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
                wr.write(req.toJson().toString());
                wr.flush();
                in = new BufferedInputStream(conn.getInputStream());
                response = convertStreamToString(in);
            }catch (Exception e) {
                e.printStackTrace();
            }
            return response;
        }
        @Override
        protected void onPostExecute(String result){
            updateChat(result);
        }
        private String convertStreamToString(InputStream is) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            StringBuilder sb = new StringBuilder();

            String line;
            try {
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append('\n');
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return sb.toString();
        }
    }
    void onSendClick(){
        EditText messageEt = (EditText) findViewById(R.id.editText);
        String text = messageEt.getText().toString();
        messageEt.setText("");
        CallAPI call = new CallAPI();
        String[] params = {this.usr, text};
        call.execute(params);
    }
    void onRefreshClick(){
        CallRefresh call = new CallRefresh();
        String[] params = {};
        call.execute(params);
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);
        i = getIntent();
        this.usr = i.getStringExtra("usr");
        this.pwd = i.getStringExtra("pwd");
        System.out.println(this.usr+this.pwd);
        Button sendBtn = (Button) findViewById(R.id.button5);
        sendBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onSendClick();
            }
        });
        Button frshBtn = (Button) findViewById(R.id.button6);
        frshBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v){
                onRefreshClick();
            }
        });
        onRefreshClick();
    }

}
