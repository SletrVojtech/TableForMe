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
<%@ page import="java.time.LocalDate" %>
<html>
<head>
    <title>Uzavření restaurace</title>
</head>
<% /*

Zde probíhá proces uzavíraní restaurace.
*/
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
/*
Nejprve se vymažou všechny existující rezervace.
 */
            PreparedStatement stm2 = conn.prepareStatement("DELETE FROM reservations WHERE idres = ? AND date=?;");
            stm2.setInt(1, id);
            LocalDate l = LocalDate.parse(request.getParameter("date"));
            stm2.setDate(2, Date.valueOf(l));
            stm2.executeUpdate();
            /*
            Poté se vytvoří speciální rezervace, kterou systém později identifikuje jako uzavřenou restauraci.
             */
            PreparedStatement stm3 = conn.prepareStatement("INSERT INTO reservations (idres,date,time,name,type ) VALUES" +
                    "(?,?,1,'ZAVŘENO',TRUE);");
            stm3.setInt(1, id);
            stm3.setDate(2, Date.valueOf(l));
            stm3.executeUpdate();
            conn.close();
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