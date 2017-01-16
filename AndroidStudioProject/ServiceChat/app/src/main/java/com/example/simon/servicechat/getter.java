package com.example.simon.servicechat;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by Simon on 16. 01. 2017.
 */

public class getter {
    String usr;
    String pwd;
    private static final String reqUrl = "http://servicechat3.somee.com/Service1.svc/Messages/";
    public getter(String username, String password){
        this.usr = username;
        this.pwd = password;
    }

    public String getData(int id){
        InputStream in = null;
        try{
            URL url = new URL(reqUrl+id);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", String.format("%s:%s", this.usr, this.pwd));
            conn.setRequestProperty("Accept", "application/json");
            conn.connect();
            in = new BufferedInputStream(conn.getInputStream());
        }catch(Exception e){
            e.printStackTrace();
        }
        return convertStreamToString(in);
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
