<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 27.01.2021
  Time: 11:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="head.jsp" %>
<%@ page import="java.sql.*" %>
<head>
    <title>Dokončení rezervace</title>
</head>
<br><br><%
    request.setCharacterEncoding("UTF-8");
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else if (request.getParameter("idres") == null) {
        response.sendRedirect("menu.jsp");
    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            request.setCharacterEncoding("UTF-8");
            int idres = Integer.parseInt(request.getParameter("idres"));
            int idus = Integer.parseInt(request.getParameter("idus"));
            String ocupation = request.getParameter("ocuppy");
            int time = Integer.parseInt(request.getParameter("time"));
            String date = request.getParameter("date");
            String name = request.getParameter("name");
            if (ocupation == null) {
                response.sendRedirect("menu.jsp");
            }
            String[] cap = ocupation.split(",");
            Integer[] capacity = new Integer[cap.length * 2];
            for (int i = 0; i < cap.length; i++) {
                String[] s = cap[i].split("/");
                capacity[i * 2] = Integer.parseInt(s[0]);
                capacity[i * 2 + 1] = Integer.parseInt(s[1]);
            }
            Array capacities = conn.createArrayOf("int4", capacity);
            PreparedStatement stm = conn.prepareStatement("INSERT INTO reservations (idres,idus,time,date,capacity,name) " +
                    "VALUES (?,?,?,?,?,?);");
            stm.setInt(1, idres);
            stm.setInt(2, idus);
            stm.setInt(3, time);
            stm.setString(4, date);
            stm.setArray(5, capacities);
            stm.setString(6, name);
            stm.executeUpdate();


%>
<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Rezervace hotova</b></h1>
    <p>Do budoucna můžete tuto a i jiné nadcházející rezervace najít na stránkách v záložce "Vaše rezervace" </p>
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