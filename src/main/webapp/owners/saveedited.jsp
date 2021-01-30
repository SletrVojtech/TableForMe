<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 11:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@include file="menu.jsp" %>

<head>
    <title>Ukládání úprav</title>
</head>
<% /*
 Zde proběhne uložení aktualizovaných dat o kapacitě a otevírací době.
*/

    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else if (request.getParameter("capacity") == null) {
        response.sendRedirect("home.jsp");
    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT id FROM owners WHERE username = ?;");

            stm.setString(1, uid);
            ResultSet rs = stm.executeQuery();
            rs.next();
            int id = rs.getInt("id");
            request.setCharacterEncoding("UTF-8");
            String open = "1";
            String close = "2";
            String par;
            Integer[] time = new Integer[14];
            SimpleDateFormat format = new SimpleDateFormat("H:m");
            java.util.Date date;
            /*
            Zde proběhne načtení hodnot pro otevírací dobu, tyto hodnoty jsou přepočteny na minuty a v poli uloženy do databáze.
             */
            for (int i = 0; i < 7; i++) {
                par = i + open;
                date = format.parse(request.getParameter(par));
                time[2 * i] = date.getHours() * 60 + date.getMinutes();
                par = i + close;
                date = format.parse(request.getParameter(par));
                time[2 * i + 1] = date.getHours() * 60 + date.getMinutes();

            }
            /*
            Kapacita je podle klíče rozložena do pole a zadána v pořadí od nejmenšího po největší stůl do databáze
             */
            String places = request.getParameter("capacity");
            String[] cap = places.split(",");
            Integer[] capacity = new Integer[cap.length * 2];
            for (int i = 0; i < cap.length; i++) {
                String[] s = cap[i].split("/");
                capacity[i * 2] = Integer.parseInt(s[0]);
                capacity[i * 2 + 1] = Integer.parseInt(s[1]);
            }
            int n = capacity.length / 2;
            int temp1;
            int temp2;
            for (int i = 0; i < n; i++) {
                for (int j = 1; j < (n - i); j++) {
                    if (capacity[2 * j - 2] > capacity[2 * j]) {
                        temp1 = capacity[2 * j - 2];
                        temp2 = capacity[2 * j - 1];
                        capacity[2 * j - 2] = capacity[2 * j];
                        capacity[2 * j] = temp1;
                        capacity[2 * j - 1] = capacity[2 * j + 1];
                        capacity[2 * j + 1] = temp2;
                    }

                }
            }
            PreparedStatement stm2 = conn.prepareStatement("UPDATE restaurants SET time=?, capacity=? WHERE id=" + id + ";");
            Array times = conn.createArrayOf("int4", time);
            Array capacities = conn.createArrayOf("int4", capacity);
            stm2.setArray(1, times);
            stm2.setArray(2, capacities);
            stm2.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

%>
<br><br>
<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Změna údajů proběhla v pořádku!</b></h1>
    <a class="btn btn-outline-success" href="home.jsp" role="button">Zpět na úvodní stránku</a>
</div>
</body>
</html>
<%
    }
%>