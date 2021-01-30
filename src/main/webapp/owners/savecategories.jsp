<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@include file="menu.jsp" %>
<head>
    <title>Title</title>
</head>
<%

    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM owners WHERE username = ?;");
            stm.setString(1, uid);
            ResultSet rs = stm.executeQuery();
            rs.next();
            int id = rs.getInt("id");
            ArrayList<Integer> arr = new ArrayList();
            String[] cat = request.getParameterValues("0");
            if (cat != null) {
                for (String s : cat
                ) {
                    arr.add(Integer.parseInt(s));
                }
            }

            //https://www.2ndquadrant.com/en/blog/using-java-arrays-to-insert-retrieve-update-postgresql-arrays/
            PreparedStatement stm2 = conn.prepareStatement("UPDATE restaurants SET category=?WHERE id=" + id + ";");
            if (cat == null) {
                stm2.setArray(1, null);
            } else {
                Array times = conn.createArrayOf("int4", arr.toArray());
                stm2.setArray(1, times);
            }

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