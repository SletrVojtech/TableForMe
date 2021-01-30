<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 8:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@include file="menu.jsp" %>
<head>
    <title>Uložení hesla</title>
</head>
<%
    /*
    Zde proběhne uložení změněného hesla.
     */
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else if (request.getParameter("oldpass") == null) {
        response.sendRedirect("home.jsp");
    } else {


        String oldpass = request.getParameter("oldpass");
        String newpass = request.getParameter("newpass");
        String newpass2 = request.getParameter("newpass2");

/*
Nejprve se zkontroluje správnost starého hesla;
 */
        Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
        PreparedStatement stm = conn.prepareStatement("SELECT id FROM owners WHERE username = ? AND password = crypt(?, password);");

        stm.setString(1, uid);
        stm.setString(2, oldpass);
        ResultSet rs = stm.executeQuery();

        if (!rs.next()) {
            conn.close();
            response.sendRedirect("editpass.jsp?err=2");
        } else if (!newpass.equals(newpass2)) {
            /*
           Zde proběhla kontrola nových hesel.
             */
            conn.close();
            response.sendRedirect("editpass.jsp?err=1");
        } else {
            PreparedStatement stm2 = conn.prepareStatement("UPDATE owners SET password = crypt(?, gen_salt('bf')) WHERE username = ?;");
            stm2.setString(1, newpass);
            stm2.setString(2, uid);
            stm2.executeUpdate();
            conn.close();
        }
%>
<br><br>
<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Změna proběhla v pořádku!</b></h1>
    <a class="btn btn-outline-success" href="home.jsp" role="button">Zpět na úvodní stránku</a>
</div>
</body>
</html>
<%
    }
%>