<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 11:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@include file="findres.jsp" %>
<html>
<head>

    <title>Table4Me</title>
</head>
<%
    /*
    Hlavní strana webu, pokud nebyl dosud uživatel přihlášen, proběhne kontrola přihlašovacích údajů.
     */
    if (null != session.getAttribute("refreshcount")) {
        session.setAttribute("refreshcount", null);
        response.setHeader("REFRESH", "0");
    }
    String uid2 = (String) session.getAttribute("user");
    if (uid2 == null) {
        String username = request.getParameter("username");
        if (username != null) {
            String pass = request.getParameter("password");
            try {
                Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
                PreparedStatement stm = conn.prepareStatement("SELECT id FROM users WHERE username = ? AND password = crypt(?, password);");

                stm.setString(1, username);
                stm.setString(2, pass);
                ResultSet rs = stm.executeQuery();
                if (rs.next()) {
                    /*
                    Přihlášení bylo úspěšné.
                     */
                    session.setAttribute("user", username);

                } else {
                    /*
                    Přihlášení bylo neúspěšné. Uživatel musí údaje zadat znovu
                     */
                    response.sendRedirect("login.jsp?err=1");
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
    }
%>

</body>
</html>
