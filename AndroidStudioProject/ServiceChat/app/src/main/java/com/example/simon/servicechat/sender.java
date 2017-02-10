package com.example.simon.servicechat;

import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by Simon on 16. 01. 2017.
 */

public class sender {
    private static final String reqUrl = "http://localhost:52686/Service1.svc/Send";
    private String usr;
    private String pwd;
    public sender(String user, String pass, String message){
        this.usr = user;
        this.pwd = pass;
        this.sendMessage(message);
    }
    public void sendMessage(String req){
        try{
            URL url = new URL(reqUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", String.format("%s:%s", this.usr, this.pwd));
            conn.setRequestProperty("Content-Type", "application/json");
            conn.connect();
            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
            wr.write(req);
            wr.flush();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
