<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 30.01.2021
  Time: 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@include file="head.jsp" %>
<html>
<head>
    <title>Rezervace zrušena</title>
</head>
<%


    if (uid == null) {
        response.sendRedirect("/TableForMe2/users/login.jsp");
    } else if (request.getParameter("id") == null) {
        response.sendRedirect("/TableForMe2/users/menu.jsp");
    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            int id = Integer.parseInt(request.getParameter("id"));
            PreparedStatement stm = conn.prepareStatement("DELETE FROM reservations WHERE id=?;");
            stm.setInt(1, id);
            stm.executeUpdate();


%>
<body>
<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Rezervace zrušena!</b></h1>
    <a class="btn btn-outline-success" href="menu.jsp" role="button">Zpět na úvodní stránku</a>
</div>
</body>
</html>
<%
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>