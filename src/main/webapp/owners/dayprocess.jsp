<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 28.01.2021
  Time: 11:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="menu.jsp" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Uzavření restaurace</title>
</head>
<%
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else if (request.getParameter("date") == null) {
        response.sendRedirect("home.jsp");
    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT id FROM owners WHERE username = ?;");
            stm.setString(1, uid);
            ResultSet rs = stm.executeQuery();
            rs.next();
            int id = rs.getInt("id");

            PreparedStatement stm2 = conn.prepareStatement("DELETE FROM reservations WHERE idres = ? AND date=?;");
            stm2.setInt(1, id);
            stm2.setString(2, request.getParameter("date"));
            stm2.executeUpdate();
            PreparedStatement stm3 = conn.prepareStatement("INSERT INTO reservations (idres,time,date,name,type ) VALUES" +
                    "(?,1,?,'ZAVŘENO',TRUE);");
            stm3.setInt(1, id);
            stm3.setString(2, request.getParameter("date"));
            stm3.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

%>
<body>
<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Restaurace bude v tento den uzavřena</b></h1>
    <a class="btn btn-outline-success" href="home.jsp" role="button">Zpět na úvodní stránku</a>
</div>
</body>
</html>
<%
    }
%>