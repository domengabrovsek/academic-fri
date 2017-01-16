package com.example.simon.servicechat;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;

import org.json.JSONArray;
import org.json.JSONObject;

public class chat extends AppCompatActivity {
    private int currentId;
    private Intent i;
    private void updateChat(String data){
        try{
            JSONArray json = new JSONArray(data);
            ScrollView scroll = (ScrollView) findViewById(R.id.scroll);
            for(int i = currentId; i < currentId + json.length(); i++){
                JSONObject o = json.getJSONObject(i-currentId);
                EditText e = new EditText(this);
                e.setText(o.getString("Username")+": "+o.getString("Text"));
                scroll.addView(e);
            }
            currentId += json.length();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    private class CallAPI extends AsyncTask<String, String, String>{
        final Context ctx = getApplicationContext();
        @Override
        protected String doInBackground(String... params) {
            getter g = new getter(i.getStringExtra("usr"), i.getStringExtra("pwd"));
            String data = g.getData(currentId);

            return data;
        }
        @Override
        protected void onPostExecute(String result){
            updateChat(result);
        }
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);
        this.currentId = 0;
        i = getIntent();
        EditText messageEt = (EditText) findViewById(R.id.editText);
        Button sendBtn = (Button) findViewById(R.id.button5);
        sendBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sender snd = new sender(i.getStringExtra("usr"), i.getStringExtra("pwd"));
            }
        });
        Button frshBtn = (Button) findViewById(R.id.button6);
        frshBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v){
                CallAPI call = new CallAPI();
                call.execute();
            }
        });
    }

}
