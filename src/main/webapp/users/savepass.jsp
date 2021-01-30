<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 8:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@include file="head.jsp" %>
<head>
    <title>Uložení hesla</title>
</head>
<%
    if (uid == null) {
        response.sendRedirect("/TableForMe2/users/menu.jsp");
    } else if (request.getParameter("pass") == null) {
        response.sendRedirect("/TableForMe2/users/menu.jsp");
    } else {


        String oldpass = request.getParameter("oldpass");
        String newpass = request.getParameter("pass");
        String newpass2 = request.getParameter("pass2");


        Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
        PreparedStatement stm = conn.prepareStatement("SELECT id FROM users WHERE username = ? AND password = crypt(?, password);");

        stm.setString(1, uid);
        stm.setString(2, oldpass);
        ResultSet rs = stm.executeQuery();
        if (!rs.next()) {
            response.sendRedirect("/TableForMe2/users/changepass.jsp?err=2");
        } else if (!newpass.equals(newpass2)) {
            response.sendRedirect("/TableForMe2/users/changepass.jsp?err=1");
        } else {
            PreparedStatement stm2 = conn.prepareStatement("UPDATE owners SET password = crypt(?, gen_salt('bf')) WHERE username = ?;");
            stm2.setString(1, newpass);
            stm2.setString(2, uid);
            stm2.executeUpdate();
        }
%>
<body>
<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Heslo změněno!</b></h1>
    <a class="btn btn-outline-success" href="menu.jsp" role="button">Zpět na úvodní stránku</a>
</div>
</body>
</html>
<%
    }
%>