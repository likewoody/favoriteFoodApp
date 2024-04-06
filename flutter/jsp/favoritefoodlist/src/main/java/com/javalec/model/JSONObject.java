package com.javalec.model;

import java.util.HashMap;
import java.util.Map;

public class JSONObject {
	// Property
	private Map<String, Object> list;
	
	// Constructor
	public JSONObject() {
		list = new HashMap<>();
	}
	
	// Method
	// Set
	public void put(String key, Object value){
		list.put(key, value);
	}
	
	// Get
	public Map<String, Object> getList() {
        return list;
    }
}
