<%  
    /*
    Date: 2024-04-08
    Author : Woody Jo
    Description : JSON을 이용한 MySQL Update Image by MultipartRequest
    */
%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	try {
		String path = request.getServletContext().getRealPath("/images");
		int maxSize = 1024 * 1024 * 10; // 1MB
		String ecType = "UTF-8";

		MultipartRequest multi = new MultipartRequest(request, path, maxSize, ecType);
%>
		{"result":"OK"}
<%

	}catch(Exception e){
		e.printStackTrace();
%>
		{"result":"ERROR"}
<%
	}
%>