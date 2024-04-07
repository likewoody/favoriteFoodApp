<%  
    /*
    Date: 2024-04-07
    Author : Woody Jo
    Description : Flutter JSON을 이용한 MySQL Update
    */
%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	String name = request.getParameter("name");
	String phone = request.getParameter("phone");
	String lat = request.getParameter("lat");
	String lng = request.getParameter("lng");
	String rate = request.getParameter("rate");
	String inputDate = request.getParameter("inputDate");
	String id = request.getParameter("id");
	
	String url_mysql = "jdbc:mysql://localhost/favoritefoodlist?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";
	
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		
		String query = "update list set name=?, phone=?, lat=?, lng=?, rate=?, inputDate=?  where id = ?";
		ps = con.prepareStatement(query);
		
		ps.setString(1, name);
		ps.setString(2, phone);
		ps.setString(3, lat);
		ps.setString(4, lng);
		ps.setString(5, rate);
		ps.setString(6, inputDate);
		ps.setString(7, id);
		
		ps.executeUpdate();
%>
		{"result":"OK"}
<%
		con.close();
		
	}catch(Exception e){
		e.printStackTrace();
%>
		{"result":"ERROR"}
<%
	}
%>


