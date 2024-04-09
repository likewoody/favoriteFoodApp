<%@page import="java.io.File"%>
<%  
    /*
    Date: 2024-04-08
    Author : Woody Jo
    Description : JSON을 이용한 MySQL ID Select
    */
%>
<%@page import="java.sql.*"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String img = request.getParameter("img");
	// String lat = request.getParameter("lat");
	// String lng = request.getParameter("lng");

	String url_mysql = "jdbc:mysql://localhost/favoritefoodlist?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	ResultSet rs = null;
	
	JSONObject jsonList = new JSONObject();
	JSONArray itemList = new JSONArray();
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		
		String query = "select id from list where img=?";
		
		ps = con.prepareStatement(query);
		ps.setString(1, img);
		// ps.setString(2, lat);
		// ps.setString(3, lng);

		rs = ps.executeQuery();
		if(rs.next()) {
			JSONObject tempJSON = new JSONObject();
			tempJSON.put("id", rs.getInt(1));
			itemList.add(tempJSON);
		}
		jsonList.put("result", itemList);
		con.close();
		out.print(jsonList);
		
	}catch(Exception e){
		e.printStackTrace();
%>
		{"result":"ERROR"}
<%
	}
%>