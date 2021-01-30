<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 28.01.2021
  Time: 9:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="menu.jsp" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Výpis rezervací</title>
</head>
<br><br>

<%
    if (uid == null) {
        response.sendRedirect("/TableForMe2/owners/login.jsp");
    } else {
        Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
        PreparedStatement stm = conn.prepareStatement("SELECT * FROM reservations JOIN owners ON " +
                "reservations.idres = owners.id WHERE owners.username = ? AND reservations.date = ?;");
        stm.setString(1, uid);
        stm.setString(2, request.getParameter("date"));
        ResultSet rs = stm.executeQuery();
        int counter = 0;
        String time;
        Array capacities;
        Integer[] capacity;
        String value;
%>
<h2><b>Nadcházející rezervace na den <%=request.getParameter("date")%>
</b></h2><br>
<%
    Boolean type = false;
    while (rs.next()) {
        if (rs.getBoolean("type") == true) {
%>
<div style="text-align: center">
    <h2 style="color: dodgerblue"><b>Restaurace je pro tento den uzavřena</b></h2>
    <a class="btn btn-outline-success" href="home.jsp" role="button">Zpět na úvodní stránku</a>
</div>
<%
        type = true;
        break;
    }
    counter++;
    time = rs.getInt("time") / 60 + ":";
    if (rs.getInt("time") % 60 / 10 == 0) {
        time += "0" + rs.getInt("time") % 60;
    } else time += rs.getInt("time") % 60;
    capacities = rs.getArray("capacity");
    capacity = (Integer[]) capacities.getArray();
    value = "";
    for (int i = 0; i < capacity.length / 2; i++) {
        value = value + capacity[2 * i] + "/" + capacity[2 * i + 1];
        if (2 * i + 2 != capacity.length) value = value + ",";
    }
%>

<div class="border border-dark rounded d-flex flex-column " style="background-color: #DA5151; color: white">
    <div class="form-row align-items-center d-flex ">

        <label class=" p-2">Na jméno: <%=rs.getString("name")%>
        </label>
        <label class=" p-2"><%=time%>
        </label>
        <label class=" p-2">Místa: <%=value%>
        </label>

    </div>
</div>
<br><br>

<%

    }
    if (counter == 0 && !type) {
%>
<div style="text-align: center">
    <h2 style="color: dodgerblue"><b>Zatím pro tento den neexistují žádné rezervace</b></h2>
    <a class="btn btn-outline-success" href="home.jsp" role="button">Zpět na úvodní stránku</a>
</div>
<%
    }


%>
<body>

</body>
</html>
<%
    }
%>