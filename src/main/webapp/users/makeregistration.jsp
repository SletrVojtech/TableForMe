<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 17:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@include file="head.jsp" %>

<head>
    <title>Registrace</title>
</head>
<%
    /*
    Zde proběhne zpracování registrace.
     */
    if (request.getParameter("name") == null) {
        response.sendRedirect("menu.jsp");
    } else {


        String name = request.getParameter("name");
        String pass = request.getParameter("pass");
        String pass2 = request.getParameter("pass2");


        Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
        /*
        Proběhne také kontrola stejnosti hesel a existence stejného uživatelského jména.
         */
        if (!pass.equals(pass2)) {
            conn.close();
            response.sendRedirect("registration.jsp?err=1");
        } else {
            PreparedStatement stm = conn.prepareStatement("SELECT id FROM users WHERE username = ?;");
            stm.setString(1, name);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                conn.close();
                response.sendRedirect("registration.jsp?err=2");


            } else {

                PreparedStatement stm2 = conn.prepareStatement("INSERT INTO users (username,password) VALUES(?,crypt(?, gen_salt('bf')));");
                stm2.setString(1, name);
                stm2.setString(2, pass);
                stm2.executeUpdate();
                conn.close();

%>

<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Gratulujeme!</b></h1>
    <p>Nyní můžete díky registraci využít služeb naší stránky naplno! Do budoucna Vám přejeme dobrou chuť! </p>
    <a class="btn btn-outline-success" href="menu.jsp" role="button">Zpět na úvodní stránku</a>
</div>

</body>
</html>
<% }
}
}
%>