<%  
    /*
    Date: 2024-04-07
    Author : Woody Jo
    Description : JSON을 이용한 MySQL Search
    */
%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String url_mysql = "jdbc:mysql://localhost/education?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";
	
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject jsonList = new JSONObject();
	JSONArray itemList = new JSONArray();
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		
		String query = "select * from list";
		ps = con.prepareStatement(query);
		rs = ps.executeQuery();
		
		while(rs.next()) {
			JSONObject tempJSON = new JSONObject();
			tempJSON.put("id", rs.getInt("id"));
			tempJSON.put("phone", rs.getString("phone"));
			tempJSON.put("lat", rs.getString("lat"));
			tempJSON.put("lng", rs.getString("lng"));
			tempJSON.put("img", rs.getBytes("img"));
			tempJSON.put("inputDate", rs.getString("inputDate"));
			itemList.add(tempJSON);
		}
		
		jsonList.put("result", itemList);
		con.close();
		out.print(jsonList);
		out.print(123123);
		
	}catch(Exception e){
		e.printStackTrace();
	}
%>


