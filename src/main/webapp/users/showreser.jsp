<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 27.01.2021
  Time: 12:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="head.jsp" %>
<%@ page import="java.sql.*" %>
<head>
    <title>Vaše rezervace</title>
</head>
<br><br>
<h2><b>Vaše nadcházející rezervace</b></h2>
<%
    /*
    Zde se vypíší všechny rezervace pro daného uživatele z databáze.
     */
    if (uid == null) {
        response.sendRedirect("menu.jsp");
    } else {
        Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
        PreparedStatement stm = conn.prepareStatement("SELECT date,time,name,idres,reservations.id FROM reservations INNER JOIN users ON reservations.idus = users.id WHERE users.username =? ORDER BY" +
                " reservations.date, reservations.time;");
        stm.setString(1, uid);
        ResultSet rs = stm.executeQuery();
        PreparedStatement stm2 = conn.prepareStatement("SELECT name,city,adress FROM restaurants WHERE id=? ");
        ResultSet rs2;
        conn.close();
        while (rs.next()) {
            stm2.setInt(1, rs.getInt("idres"));
            rs2 = stm2.executeQuery();
            rs2.next();
            String time = rs.getInt("time") / 60 + ":";
            if (rs.getInt("time") % 60 / 10 == 0) {
                time += "0" + rs.getInt("time") % 60;
            } else time += rs.getInt("time") % 60;
%>
<div class="border border-dark rounded d-flex flex-column " style="background-color: cornflowerblue; color: white">
    <div class="form-row align-items-center d-flex ">
        <label class="p-3 "><b><%=rs2.getString("name")%>
        </b></label>
        <label class=" p-2"><%=rs.getDate("date")%>
        </label>
        <label class=" p-2"><%=time%>
        </label>
        <label class=" p-2">Na jméno: <%=rs.getString("name")%>
        </label>
        <form action="deleteres.jsp" method="post">
            <input type="hidden" name="id" value="<%=rs.getInt("id")%>">
            <button type="submit" class="btn btn-danger  ">Zrušit rezervaci</button>
        </form>

    </div>
    <div class="form-row align-items-center d-flex ">
        <label class="p-3 "><b><%=rs2.getString("city")%>
        </b></label>
        <label class=" p-2"><%=rs2.getString("adress")%>
        </label>
    </div>
</div>
<br><br>
<%

    }

%>

</body>
</html>
<%
    }
%>