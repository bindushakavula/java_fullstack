<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userEmail = (String) session.getAttribute("email");
%>
<html>
<head>
    <title>Image Display</title>
</head>
<body>
    <h1>Image Display</h1>
    
    <h2>Image for user: <%= userEmail %></h2>
    <img src="image-display.jsp?userEmail=<%= userEmail %>" alt="User Image" />
</body>
</html>
