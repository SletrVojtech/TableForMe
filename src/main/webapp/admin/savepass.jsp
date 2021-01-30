<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 27.01.2021
  Time: 18:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Uložení hesla</title>
</head>
<%

    request.setCharacterEncoding("UTF-8");
    String uid = (String) session.getAttribute("admin");
    if (uid == null) {
        response.sendRedirect("adminLogin.jsp");
    } else if (request.getParameter("pass") == null) {
        response.sendRedirect("home.jsp");
    } else {
        try {

            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm2 = conn.prepareStatement("UPDATE owners SET password = crypt(?, gen_salt('bf')) WHERE id = ?;");
            stm2.setString(1, request.getParameter("pass"));
            stm2.setInt(2, Integer.parseInt(request.getParameter("id")));

            stm2.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

%>
<body>
<a href="home.jsp">Zpět</a>
</body>
</html>
<%
    }
%>