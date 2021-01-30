<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 22:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.time.LocalDateTime" %>
<%@include file="menu.jsp" %>
<head>
    <title>Dostupnost</title>
</head>
<br><br>

<%
    if (uid == null) {
        response.sendRedirect("/TableForMe2/owners/login.jsp");
    } else if (request.getParameter("date") == null) {
        response.sendRedirect("/TableForMe2/owners/home.jsp");
    } else {
        String[] date = request.getParameter("date").split("-");
        LocalDate l = LocalDate.of(Integer.parseInt(date[0]), Integer.parseInt(date[1]), Integer.parseInt(date[2]));
        LocalDateTime now = LocalDateTime.now();
        int year = now.getYear();
        int month = now.getMonthValue();
        String month2 = "";
        String day3 = "";
        int day2 = now.getDayOfMonth();
        if (month / 10 == 0) {
            month2 = "0" + month;
        } else {
            month2 += month;
        }
        if (day2 / 10 == 0) {
            day3 = "0" + day2;
        } else {
            day3 += day2;
        }
        int hour = now.getHour();
        int minute = now.getMinute();
        String today = year + "-" + month2 + "-" + day3;
        int todaytime = hour * 60 + minute + 30;
        String[] time = request.getParameter("time").split(":");
        int minutes = Integer.parseInt(time[0]) * 60 + Integer.parseInt(time[1]);
        if (today.equals(request.getParameter("date")) && todaytime > minutes) {
            response.sendRedirect("/TableForMe2/owners/reservation.jsp?err=1");
        } else {


            try {
                Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
                PreparedStatement stm = conn.prepareStatement("SELECT * FROM restaurants WHERE id=?;");
                stm.setInt(1, Integer.parseInt(request.getParameter("id")));
                ResultSet rs = stm.executeQuery();

                int id;
                rs.next();
                //https://www.geeksforgeeks.org/dayofweek-getvalue-method-in-java-with-examples/

                DayOfWeek dayOfWeek = DayOfWeek.from(l);
                int day = dayOfWeek.getValue();

                Array a = rs.getArray("time");
                Integer[] times = (Integer[]) a.getArray();

                id = rs.getInt("id");


                if (times[day * 2 - 2] > minutes || (times[day * 2 - 1] - 90) < minutes) {
                    response.sendRedirect("/TableForMe2/owners/reservation.jsp?err=2");
                } else {
                    Statement s2 = conn.createStatement();
                    ResultSet rs3 = s2.executeQuery("SELECT type FROM reservations WHERE date='" + request.getParameter("date") + "'" +
                            "AND idRes=" + id + "AND time =1;");
                    if (rs3.next() && rs3.getBoolean("type") == true) {
                        response.sendRedirect("/TableForMe2/owners/reservation.jsp?err=2");
                    } else {


                        Array places = rs.getArray("capacity");
                        Integer[] capacity = (Integer[]) places.getArray();
                        Integer[] min = capacity;
                        ArrayList<Integer[]> line = new ArrayList();
                        ArrayList<Integer> linetime = new ArrayList();
                        Statement s = conn.createStatement();
                        ResultSet rs2 = s.executeQuery("SELECT time,capacity FROM reservations WHERE date='" + request.getParameter("date") + "'" +
                                "AND idRes=" + id + "AND time BETWEEN " + (minutes - 120) + " AND " + (minutes + 120) + "; ");
                        Array actualar;
                        Integer[] actual;
                        int counter;
                        while (rs2.next()) {

                            linetime.add(rs2.getInt("time") + 120);
                            actualar = rs2.getArray("capacity");
                            actual = (Integer[]) actualar.getArray();
                            line.add(actual);
                            counter = 0;
                            for (int i = 0; i < actual.length; i += 2) {
                                while (actual[i] != capacity[counter]) {
                                    counter += 2;
                                }
                                capacity[counter + 1] -= actual[i + 1];
                            }
                            while (linetime.get(0) < rs2.getInt("time")) {
                                actual = line.get(0);
                                line.remove(0);
                                linetime.remove(0);
                                counter = 0;
                                for (int i = 0; i < actual.length; i += 2) {
                                    while (actual[i] != capacity[counter]) {
                                        counter += 2;
                                    }
                                    capacity[counter + 1] += actual[i + 1];
                                }
                            }

                            for (int i = 0; i < capacity.length; i += 2) {
                                if (min[i + 1] > capacity[i + 1]) {
                                    min[i + 1] = capacity[i + 1];
                                }
                            }
                        }
                        int mincapacity = 0;
                        for (int i = 0; i < min.length; i += 2) {
                            mincapacity += min[i] * min[i + 1];
                        }

                        int number = Integer.parseInt(request.getParameter("number"));
                        if (mincapacity < number) {
                            response.sendRedirect("/TableForMe2/owners/reservation.jsp?err=3");
                        } else {
                            int lenght = min.length;
                            Integer[] occupation = min.clone();

                            for (int i = 0; i < lenght; i += 2) {
                                occupation[i + 1] = 0;
                            }

                            int[] diff = new int[lenght / 2];

                            while (number > 0) {

                                for (int i = 0; i < lenght / 2; i++) {
                                    if (min[i * 2 + 1] == 0) {
                                        diff[i] = -100;
                                    } else {
                                        diff[i] = number - min[i * 2];
                                    }
                                }
                                int minus = -100;
                                int plus = 100;
                                int var1 = 0;
                                int var2 = 0;
                                int nt;
                                for (int i = 0; i < lenght / 2; i++) {
                                    nt = diff[i];
                                    if (nt == 0) {
                                        minus = 0;
                                        var1 = i;
                                        break;
                                    } else if (nt < 0 && nt > minus) {
                                        minus = nt;
                                        var1 = i;
                                    } else if (nt > 0 && nt < plus) {
                                        plus = nt;
                                        var2 = i;
                                    }
                                }

                                if ((minus + plus) == 0 || ((-1) * minus < plus)) {
                                    number = 0;
                                    occupation[2 * var1 + 1] += 1;
                                    min[2 * var1 + 1] -= 1;
                                } else {
                                    number -= min[var2 * 2];
                                    occupation[2 * var2 + 1] += 1;
                                    min[2 * var2 + 1] -= 1;
                                }


                            }
                            ArrayList<Integer> occupation2 = new ArrayList();
                            for (int i = 0; i < occupation.length / 2; i++) {
                                if (occupation[i * 2 + 1] != 0) {
                                    occupation2.add(occupation[i * 2]);
                                    occupation2.add(occupation[i * 2 + 1]);
                                }
                            }
                            Array capacities = conn.createArrayOf("int4", occupation2.toArray());
                            PreparedStatement stm2 = conn.prepareStatement("INSERT INTO reservations (idres,time,date,capacity,name) " +
                                    "VALUES (?,?,?,?,?);");
                            stm2.setInt(1, id);
                            stm2.setInt(2, minutes);
                            stm2.setString(3, request.getParameter("date"));
                            stm2.setArray(4, capacities);
                            stm2.setString(5, request.getParameter("name"));
                            stm2.executeUpdate();

                        }


%>
<div style="text-align: center">
    <h1 style="color: dodgerblue"><b>Zarezervováno!</b></h1>
    <a class="btn btn-outline-success" href="home.jsp" role="button">Zpět na úvodní stránku</a>
</div>
<%


            }
        }

    } catch (Exception e) {
        System.out.println(e);
        e.printStackTrace();
    }
%>


</body>
</html>
<%
        }
    }
%>