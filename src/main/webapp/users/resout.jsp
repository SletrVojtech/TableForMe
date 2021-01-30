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
<%@include file="head.jsp" %>
<head>
    <title>Dostupné restaurace</title>
</head>
<br><br>
<h3>Výpis nalezených restaurací</h3><br>

<%
    if (uid == null) {
        response.sendRedirect("/TableForMe2/users/login.jsp");
    } else if (request.getParameter("date") == null) {
        response.sendRedirect("/TableForMe2/users/menu.jsp");
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
            response.sendRedirect("/TableForMe2/users/findres.jsp?err=1");
        } else {


            try {
                Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
                PreparedStatement stm;
                ResultSet rs;
                if (request.getParameter("id") != null) {
                    System.out.println("jsem tu s id");
                    stm = conn.prepareStatement("SELECT * FROM restaurants WHERE id=?;");
                    stm.setInt(1, Integer.parseInt(request.getParameter("id")));
                    rs = stm.executeQuery();
                } else if ((!request.getParameter("city").equals("")) && request.getParameterValues("0") != null) {
                    String[] arr = request.getParameterValues("0");
                    String s = "SELECT * FROM restaurants WHERE city=? AND ? = ANY(category)";
                    String p = "OR ? = ANY (category)";
                    for (int i = 1; i < arr.length; i++) {
                        s += p;
                    }
                    s += ";";

                    stm = conn.prepareStatement(s);
                    stm.setString(1, request.getParameter("city"));
                    for (int i = 2; i < arr.length + 2; i++) {
                        stm.setInt(i, Integer.parseInt(arr[i - 2]));
                    }
                    rs = stm.executeQuery();
                } else if ((!request.getParameter("city").equals(""))) {
                    stm = conn.prepareStatement("SELECT * FROM restaurants WHERE city=?");
                    stm.setString(1, request.getParameter("city"));
                    rs = stm.executeQuery();
                } else if (request.getParameterValues("0") != null) {
                    String[] arr = request.getParameterValues("0");
                    String s = "SELECT * FROM restaurants WHERE ? = ANY (category)";
                    String p = "OR ? = ANY (category)";
                    for (int i = 1; i < arr.length; i++) {
                        s += p;
                    }

                    stm = conn.prepareStatement(s);
                    for (int i = 1; i < arr.length + 1; i++) {
                        stm.setInt(i, Integer.parseInt(arr[i - 1]));
                    }
                    rs = stm.executeQuery();
                } else {
                    stm = conn.prepareStatement("SELECT * FROM restaurants;");
                    rs = stm.executeQuery();
                }
                String[] types = new String[]{"česká a tradiční", "evropská", "americká", "asijská"};
                String name, description, city;
                int id;
                Integer[] category = null;
                while (rs.next()) {
                    //https://www.geeksforgeeks.org/dayofweek-getvalue-method-in-java-with-examples/

                    DayOfWeek dayOfWeek = DayOfWeek.from(l);
                    int day = dayOfWeek.getValue();

                    Array a = rs.getArray("time");
                    Integer[] times = (Integer[]) a.getArray();


                    name = rs.getString("name");
                    description = rs.getString("description");
                    if (description == null) description = "";
                    city = rs.getString("city");
                    id = rs.getInt("id");
                    Array categories = rs.getArray("category");
                    if (categories != null) category = (Integer[]) categories.getArray();


%>

<div class="border border-dark rounded d-flex flex-column ">
    <div class="form-row align-items-center d-flex ">
        <label class="p-3 "><b><%=name%>
        </b></label>
        <label class=" p-2"><%=city%>
        </label>
        <form action="makereser.jsp" method="post">
            <div class="ml-auto p-2">
                <input type="hidden" name="id" value="<%=id%>">

                <%
                    if (times[day * 2 - 2] > minutes || (times[day * 2 - 1] - 90) < minutes) {
                %>
                <button type="submit" class="btn btn-danger  " disabled>Zavřeno</button>
                <button type="submit" class="btn btn-primary">Informace o restauraci</button>


                <%
                } else {
                    Statement s2 = conn.createStatement();
                    ResultSet rs3 = s2.executeQuery("SELECT type FROM reservations WHERE date='" + request.getParameter("date") + "'" +
                            "AND idRes=" + id + "AND time =1;");
                    if (rs3.next() && rs3.getBoolean("type") == true) {
                %>

                <button type="submit" class="btn btn-danger  " disabled>Zavřeno</button>
                <button type="submit" class="btn btn-primary">Informace o restauraci</button>


                <%
                } else {


                    Array places = rs.getArray("capacity");
                    Integer[] capacity = (Integer[]) places.getArray();
                    Integer[] min = capacity;
                    ArrayList<Integer[]> line = new ArrayList();
                    ArrayList<Integer> linetime = new ArrayList();
                    Statement s = conn.createStatement();
                    ResultSet rs2 = s.executeQuery("SELECT * FROM reservations WHERE date='" + request.getParameter("date") + "'" +
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
                %>

                <button type="submit" class="btn btn-warning  " disabled>Obsazeno</button>
                <button type="submit" class="btn btn-primary">Informace o restauraci</button>

                <%
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
                    String occ = "";

                    for (int i = 0; i < lenght; i += 2) {
                        if (occupation[i + 1] != 0) {
                            occ = occ + occupation[i] + "/" + occupation[i + 1] + ",";
                        }
                    }
                    occ = occ.substring(0, occ.length() - 1);


                %>
                <input type="hidden" name="ocuppy" value="<%=occ%>">
                <input type="hidden" name="time" value="<%=minutes%>">
                <input type="hidden" name="date" value="<%=request.getParameter("date")%>">
                <button type="submit" class="btn btn-success  ">Pokračovat v rezervaci</button>

                <%
                            }


                        }
                    }

                %>


            </div>
        </form>
    </div>
    <label class="p-2"><%=description%>
    </label>
    <div class="form-row align-items-center d-flex flex-wrap">
        <%

            if (category != null) {
                for (int i : category
                ) {
        %>
        <label class="p-3" style="color: firebrick"><b><%=types[i]%>
        </b></label>
        <%
                }
            }
        %>

    </div>
</div>
<br><br>
<%

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