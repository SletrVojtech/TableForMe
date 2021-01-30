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
<%@ page import="java.time.LocalTime" %>
<%@include file="menu.jsp" %>
<head>
    <title>Dostupnost</title>
</head>
<br><br>

<%
    /*
    Zde probíhá zpracování rezervace přidané majitelem restaurace.
     */
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else if (request.getParameter("date") == null) {
        response.sendRedirect("home.jsp");
    } else {
        /*
        Nejdříve se ověří, zda není rezervace na čas, který již proběhl. Rezervaci není možné vytvořit na bližší termín než za 30 minut od aktuálního času.
         */
        LocalDate l = LocalDate.parse(request.getParameter("date"));
        LocalDate nowtime = LocalDate.now();
        LocalTime now = LocalTime.now();

        int hour = now.getHour();
        int minute = now.getMinute();
        int todaytime = hour * 60 + minute + 90;
        String[] time = request.getParameter("time").split(":");
        int minutes = Integer.parseInt(time[0]) * 60 + Integer.parseInt(time[1]);
        if (l.isEqual(nowtime) && todaytime > minutes) {
            response.sendRedirect("reservation.jsp?err=1");
        } else {


            try {
                /*
                Pokud splňuje předchozí podmínku, načtou se data o restauraci a ověří se, zda není rezervace na termín
                před otevírací dobou nebo méně než 90 minut před zavírací dobou. Všechny rezervace jsou na dobu 90 minut
                pobytu hosta + 30 minut na uklizení restaurace.
                 */
                Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
                PreparedStatement stm = conn.prepareStatement("SELECT * FROM restaurants WHERE id=?;");
                stm.setInt(1, Integer.parseInt(request.getParameter("id")));
                ResultSet rs = stm.executeQuery();

                int id;
                rs.next();

                DayOfWeek dayOfWeek = DayOfWeek.from(l);
                int day = dayOfWeek.getValue();

                Array a = rs.getArray("time");
                Integer[] times = (Integer[]) a.getArray();

                id = rs.getInt("id");


                if (times[day * 2 - 2] > minutes || (times[day * 2 - 1] - 90) < minutes) {
                    response.sendRedirect("reservation.jsp?err=2");
                } else {
                    /*
                    Zde se ověří zda není tato restaurace pro daný den uzavřena.
                     */
                    PreparedStatement s2 = conn.prepareStatement("SELECT type FROM reservations WHERE date=? AND idRes=? AND time =1;");
                    s2.setDate(1,Date.valueOf(l));
                    s2.setInt(2,id);
                    ResultSet rs3 = s2.executeQuery();
                    if (rs3.next() && rs3.getBoolean("type") == true) {
                        response.sendRedirect("reservation.jsp?err=2");
                    } else {

                        /*
                        Pokud není, začne výpočet dostupné kapacity restaurace. Ta probíhá čtením z fronty a
                        zaznamenáváním minimálních hodnot pro každý typ stolu.
                         */
                        Array places = rs.getArray("capacity");
                        Integer[] capacity = (Integer[]) places.getArray();
                        Integer[] min = capacity;
                        ArrayList<Integer[]> line = new ArrayList();
                        ArrayList<Integer> linetime = new ArrayList();
                        PreparedStatement s = conn.prepareStatement("SELECT time,capacity FROM reservations WHERE date= ?AND idRes= ?AND time BETWEEN ? AND ?; ");
                        s.setDate(1, Date.valueOf(l));
                        s.setInt(2,id);
                        s.setInt(3,minutes -120);
                        s.setInt(4, minutes +120);
                       ResultSet rs2 = s.executeQuery();
                        Array actualar;
                        Integer[] actual;
                        int counter;
                        while (rs2.next()) {
                            /*
                            Zde se přidá nalezená rezervace z databáze a uberou se stoly, které obsadí.
                             */
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
                                /*
                                Zde se naopak přičtou místa z rezervací, kterým již vypršel časový fond.
                                 (restaurace je schopna tyto prostory obsadit znovu)
                                 */
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
                            /*
                            Zde se porovnají minimální hodnoty kapacity.
                             */
                            for (int i = 0; i < capacity.length; i += 2) {
                                if (min[i + 1] > capacity[i + 1]) {
                                    min[i + 1] = capacity[i + 1];
                                }
                            }
                        }
                        /*
                        Po zpracování všech předchozích rezervací se vypočte maximální zbývající kapacita restaurace po celou dobu pobytu.
                         */
                        int mincapacity = 0;
                        for (int i = 0; i < min.length; i += 2) {
                            mincapacity += min[i] * min[i + 1];
                        }

                        int number = Integer.parseInt(request.getParameter("number"));
                        if (mincapacity < number) {
                            /*
                            Pokud je kapacita menší než počet požadovaných míst, rezervace neproběhne.
                             */
                            response.sendRedirect("reservation.jsp?err=3");
                        } else {
                            /*
                            Pokud je kapacita dostačující proběhne výpočet optimálního usazení hostů. Algoritmus
                            preferuje usazení k jednomu stolu větší kapacity než k více menším stolům na úkor ztráty kapacity.
                            A to z důvodu pohodlí hostů a také snažší přípravy restaurace.
                             */
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
                            /*
                            Rezervace se přidá do databáze a tím se stane platnou.
                             */
                            Array capacities = conn.createArrayOf("int4", occupation2.toArray());
                            PreparedStatement stm2 = conn.prepareStatement("INSERT INTO reservations (idres,time,date,capacity,name) " +
                                    "VALUES (?,?,?,?,?);");
                            stm2.setInt(1, id);
                            stm2.setInt(2, minutes);
                            stm2.setDate(3, Date.valueOf(l));
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