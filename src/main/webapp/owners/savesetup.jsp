<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 0:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@include file="menu.jsp" %>
<head>
    <title>Ukládání dat restaurace</title>
</head>
<%
    if (uid == null) {
        response.sendRedirect("/TableForMe2/owners/login.jsp");
    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM owners WHERE username = ?;");

            stm.setString(1, uid);
            ResultSet rs = stm.executeQuery();
            rs.next();
            String name = rs.getString("name");
            int id = rs.getInt("id");
            request.setCharacterEncoding("UTF-8");
            String city = request.getParameter("city");
            if (city == null) {
                response.sendRedirect("/TableForMe2/owners/home.jsp");
            } else {
                String adress = request.getParameter("adress");
                String open = "1";
                String close = "2";
                String par;
                Integer[] time = new Integer[14];
                SimpleDateFormat format = new SimpleDateFormat("H:m");
                java.util.Date date;
                //https://stackoverflow.com/questions/14359037/how-can-i-convert-a-string-hhmm-to-a-int-hour-hh-and-int-minute-mm
                for (int i = 0; i < 7; i++) {
                    par = i + open;
                    date = format.parse(request.getParameter(par));
                    time[2 * i] = date.getHours() * 60 + date.getMinutes();
                    par = i + close;
                    date = format.parse(request.getParameter(par));
                    time[2 * i + 1] = date.getHours() * 60 + date.getMinutes();

                }
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
                //https://www.2ndquadrant.com/en/blog/using-java-arrays-to-insert-retrieve-update-postgresql-arrays/
                //https://www.postgresql.org/message-id/1349107725.96229.YahooMailNeo@web120301.mail.ne1.yahoo.com
                PreparedStatement stm2 = conn.prepareStatement("INSERT INTO restaurants (id,name,city,adress,time,capacity) " +
                        "VALUES (" + id + ",'" + name + "',?,?,?,?);");
                stm2.setString(1, city);
                stm2.setString(2, adress);
                Array times = conn.createArrayOf("int4", time);
                Array capacities = conn.createArrayOf("int4", capacity);
                stm2.setArray(3, times);
                stm2.setArray(4, capacities);
                stm2.executeUpdate();
                Statement stm3 = conn.createStatement();
                stm3.executeUpdate("UPDATE owners SET state= TRUE WHERE id=" + id + ";");
                conn.close();
            }

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