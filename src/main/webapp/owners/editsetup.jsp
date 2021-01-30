<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 9:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@include file="menu.jsp" %>
<head>
    <title>Úprava dat restaurace</title>
</head>
<br><br>
<div class="d-flex justify-content-center">
    <form action="saveedited.jsp" method="post">
        <% /*
        Zde může restauratér upravit otevírací dobu a kapacitu restaurace. Zprvu se načtou původní hodnoty.
        */

            if (uid == null) {
                response.sendRedirect("login.jsp");
            } else {


                Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
                PreparedStatement stm = conn.prepareStatement("SELECT time,capacity FROM restaurants JOIN owners ON restaurants.id = owners.id WHERE owners.username=? ;");
                stm.setString(1, uid);
                ResultSet rs = stm.executeQuery();


                if (rs.next()) {

                    Array times = rs.getArray("time");
                    Array capacities = rs.getArray("capacity");
                    String[] dny = new String[]{"Pondělí:", "Úterý:", "Středa:", "Čtvrtek:", "Pátek:", "Sobota:", "Neděle:"};
                    Integer[] time = (Integer[]) times.getArray();
                    Integer[] capacity = (Integer[]) capacities.getArray();
                    String dop, dcl;
                    for (int i = 0; i < time.length / 2; i++) {
                        dop = i + "1";
                        dcl = i + "2";

                        String so = "";
                        if (time[2 * i] / 60 / 10 == 0) {
                            so = "0" + time[2 * i] / 60;
                        } else {
                            so = "" + time[2 * i] / 60;
                        }
                        so += ":";
                        if (time[2 * i] % 60 / 10 == 0) {
                            so = so + "0" + time[2 * i] % 60;
                        } else {
                            so = so + time[2 * i] % 60;
                        }
                        String sc = "";
                        if (time[2 * i + 1] / 60 / 10 == 0) {
                            sc = "0" + time[2 * i + 1] / 60;
                        } else {
                            sc = "" + time[2 * i + 1] / 60;
                        }
                        sc += ":";
                        if (time[2 * i + 1] % 60 / 10 == 0) {
                            sc = sc + "0" + time[2 * i + 1] % 60;
                        } else {
                            sc = sc + time[2 * i + 1] % 60;
                        }

        %>
        <div class="d-flex flex-row">
            <label class="p-2" for="<%=dop%>"><%=dny[i]%> od</label>
            <input class="p-2" type="time" id="<%=dop%>" name="<%=dop%>" value="<%=so%>"/>
            <label class="p-2" for="<%=dcl%>">do</label>
            <input class="p-2" type="time" name="<%=dcl%>" id="<%=dcl%>" value="<%=sc%>"/> <br>
        </div>
        <br>
        <%
            }
            String value = "";
            for (int i = 0; i < capacity.length / 2; i++) {
                value = value + capacity[2 * i] + "/" + capacity[2 * i + 1];
                if (2 * i + 2 != capacity.length) value = value + ",";
            }
        %>
        <div class="d-flex flex-column">
            <h3>Kapacity restaurace</h3>
            <p>Kapacitu zadávejte prosím do následujícího pole ve formátu: kapacita stolu/počet stolů,kapacita
                stolu...</p>
            <input type="text" name="capacity" pattern="[0-9/,].{3,}" required value="<%=value%>"><br><br>
        </div>
        <%


            }
            conn.close();
        %>

        <button type="submit" class="btn btn-primary">Změnit údaje</button>
    </form>
</div>
</body>
</html>
<%
    }
%>