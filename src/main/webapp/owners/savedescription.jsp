<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 15:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@include file="menu.jsp" %>
<head>
    <title>Ukládání popisku restaurace</title>
</head>
<%
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT id FROM owners WHERE username = ?;");
            stm.setString(1, uid);
            ResultSet rs = stm.executeQuery();
            rs.next();
            int id = rs.getInt("id");
            request.setCharacterEncoding("UTF-8");
            String description = request.getParameter("description");
            PreparedStatement stm2 = conn.prepareStatement("UPDATE restaurants SET description=?WHERE id=" + id + ";");
            stm2.setString(1, description);
            stm2.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

%>
<br><br>
<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Údaje uloženy!</b></h1>
    <a class="btn btn-outline-success" href="home.jsp" role="button">Zpět na úvodní stránku</a>
</div>
</body>
</html>
<%
    }
%>