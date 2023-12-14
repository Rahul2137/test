package com.sundatabase.test;

import com.squareup.okhttp.*;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;

@RestController
public class LoginController {

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");

        try {
            String token = requestTokenFromExternalServer(username, password);
            return ResponseEntity.status(HttpStatus.OK).body(Collections.singletonMap("token", token));
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Collections.singletonMap("error", "Internal Server Error"));
        } catch (InvalidCredentialsException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Collections.singletonMap("error", "Invalid username or password"));
        }
    }

    private String requestTokenFromExternalServer(String username, String password) throws IOException {
        String tokenEndpoint = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment_auth.jsp";
        OkHttpClient client = new OkHttpClient();
        String json = String.format("{\n  \"login_id\":  %s,\n  \"password\":  %s\n}", username, password);
        MediaType mediaType = MediaType.parse("application/json");
        com.squareup.okhttp.RequestBody body = com.squareup.okhttp.RequestBody.create(mediaType, json);
        Request request = new Request.Builder()
                .url(tokenEndpoint)
                .post(body)
                .addHeader("Content-Type", "application/json")
                .build();

        try {
            Response response = client.newCall(request).execute();

            if (!response.isSuccessful()) {
                throw new InvalidCredentialsException();
            }
            JSONObject res = new JSONObject(response.body().string());
            return res.getString("access_token");
        } catch (IOException | JSONException e) {
            throw new RuntimeException(e);
        }
    }

    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    private static class InvalidCredentialsException extends RuntimeException {
    }
}
