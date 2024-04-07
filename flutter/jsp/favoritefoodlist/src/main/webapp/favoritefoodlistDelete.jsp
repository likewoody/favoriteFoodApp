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

	String id = request.getParameter("id");
	
	String url_mysql = "jdbc:mysql://localhost/favoritefoodlist?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";
	
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		
		String query = "delete from list where id = ?";
		ps = con.prepareStatement(query);
		
		ps.setString(1, id);
		
		
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


