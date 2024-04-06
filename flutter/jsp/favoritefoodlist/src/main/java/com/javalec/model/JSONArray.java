package com.javalec.model;

import java.util.ArrayList;
import java.util.Map;

public class JSONArray {

	// Property
	private ArrayList<JSONObject> list;

	// Constructor
	public JSONArray() {
		list = new ArrayList<JSONObject>();
	}
	
	// Method
	// Set
	public void add(JSONObject tempJSON) {
		list.add(tempJSON);
	}
//	// Get
//	public ArrayList<Map<String, Object>> getList(){
//		return list;
//	} 
//	
	
}
