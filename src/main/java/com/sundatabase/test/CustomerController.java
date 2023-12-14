package com.sundatabase.test;

import com.google.gson.Gson;
import com.squareup.okhttp.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;

@Controller
public class CustomerController {
    @PostMapping("/createCustomer")
    public ResponseEntity<Map<String, String>> createCustomer(@org.springframework.web.bind.annotation.RequestBody Customer formData, @RequestHeader Map<String, String> headers) {
        try {
            createCustomerOnSunDatabase(formData, headers);
        } catch (IOException e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Collections.singletonMap("error", e.getMessage()));
        }
        return ResponseEntity.status(HttpStatus.OK).body(Collections.singletonMap("msg", "Customer created successfully"));
    }

    @GetMapping("/getCustomersData")
    public ResponseEntity<Map<String, String[]>> getCustomerDetails(@RequestHeader Map<String, String> headers) {
        if(!headers.containsKey("authorization")){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Collections.singletonMap("error", new String[]{"Not Authorized"}));
        }
        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url("https://qa2.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=get_customer_list")
                .get()
                .addHeader("Authorization", "Bearer "+ headers.get("authorization"))
                .build();

        try {
            Response response = client.newCall(request).execute();
            Gson gson = new Gson();
            Customer[] customersArray = gson.fromJson(response.body().charStream(), Customer[].class);
            String[] jsonsArray = new String[customersArray.length];
            for (int i = 0; i < customersArray.length; i++) {
                jsonsArray[i] = gson.toJson(customersArray[i]);
            }
            return ResponseEntity.status(HttpStatus.OK).body(Collections.singletonMap("data", jsonsArray));
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Collections.singletonMap("error", new String[]{e.getMessage()}));
        }

    }

    @PostMapping("/deleteCustomer")
    public ResponseEntity<Map<String, String>> deleteCustomer(@RequestParam String uuid, @RequestHeader Map<String, String> headers) {
        try {
            OkHttpClient client = new OkHttpClient();
            String urlEndpoint = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=delete&uuid=" + uuid;
            MediaType mediaType = MediaType.parse("application/json");
            com.squareup.okhttp.RequestBody body = com.squareup.okhttp.RequestBody.create(mediaType, "");
            Request request = new Request.Builder()
                    .url(urlEndpoint)
                    .post(body)
                    .addHeader("Content-Type", "application/json")
                    .addHeader("Authorization", "Bearer " + headers.get("authorization"))
                    .build();
            try {
                Response response = client.newCall(request).execute();
                if (!response.isSuccessful()) {
                    if(response.code() == 400){
                        return ResponseEntity.status(400).body(Collections.singletonMap("msg", "No customer with given uuid"));
                    }else if(response.code() == 401){
                        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Collections.singletonMap("error", "Token invalid"));
                    }
                    throw new RuntimeException(response.message());
                }
                if (response.body() != null) {
                    response.body().close();
                }
                return ResponseEntity.status(HttpStatus.OK).body(Collections.singletonMap("msg", "Customer deleted successfully"));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        } catch (RuntimeException e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Collections.singletonMap("error", e.getMessage()));
        }
    }

    @PostMapping("/updateCustomer")
    public ResponseEntity<Map<String, String>> updateCustomer(@org.springframework.web.bind.annotation.RequestBody Customer formData, @RequestHeader Map<String, String> headers) {
        try {
            updateCustomerOnSunDatabase(formData, headers);
        } catch (IOException e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Collections.singletonMap("error", e.getMessage()));
        }
        return ResponseEntity.status(HttpStatus.OK).body(Collections.singletonMap("msg", "Customer updated successfully"));
    }
    private void createCustomerOnSunDatabase(Customer formData, Map<String, String> headers) throws IOException {
        OkHttpClient client = new OkHttpClient();
        MediaType mediaType = MediaType.parse("application/json");
        Gson gson = new Gson();
        String json = gson.toJson(formData);
        com.squareup.okhttp.RequestBody body = com.squareup.okhttp.RequestBody.create(mediaType, json);
        String urlEndpoint = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=create";
        Request request = new Request.Builder()
                .url(urlEndpoint)
                .post(body)
                .addHeader("Content-Type", "application/json")
                .addHeader("Authorization", "Bearer " + headers.get("authorization"))
                .build();
        try {
            Response response = client.newCall(request).execute();
            if (!response.isSuccessful()) {

                throw new RuntimeException(response.message());
            }
            if (response.body() != null) {
                response.body().close();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void updateCustomerOnSunDatabase(Customer formData, Map<String, String> headers) throws IOException {
        OkHttpClient client = new OkHttpClient();
        MediaType mediaType = MediaType.parse("application/json");
        Gson gson = new Gson();
        String json = gson.toJson(formData);
        com.squareup.okhttp.RequestBody body = com.squareup.okhttp.RequestBody.create(mediaType, json);
        String urlEndpoint = "https://qa2.sunbasedata.com/sunbase/portal/api/assignment.jsp?cmd=update&uuid=" + formData.getUuid();
        Request request = new Request.Builder()
                .url(urlEndpoint)
                .post(body)
                .addHeader("Content-Type", "application/json")
                .addHeader("Authorization", "Bearer " + headers.get("authorization"))
                .build();
        try {
            Response response = client.newCall(request).execute();
            if (!response.isSuccessful()) {
                throw new RuntimeException(response.message());
            }
            if (response.body() != null) {
                response.body().close();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
