<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 27.01.2021
  Time: 10:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="head.jsp" %>
<%@ page import="java.sql.*" %>
<head>
    <title>Dokončení rezervace</title>
</head>
<br><br><%
    /*
    Zde může uživatel vidět podrobnosti restaurace a pokud byl dostupný termín tak může i dokončit rezervaci.
     */
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else if (request.getParameter("id") == null) {
        response.sendRedirect("menu.jsp");
    } else {


        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT id FROM users WHERE username=?;");
            stm.setString(1, uid);
            ResultSet rs = stm.executeQuery();
            rs.next();
            request.setCharacterEncoding("UTF-8");
            int idus = rs.getInt("id");
            int idres = Integer.parseInt(request.getParameter("id"));
            String ocupation = request.getParameter("ocuppy");
            if (request.getParameter("id").isEmpty()) {
                conn.close();
                response.sendRedirect("menu.jsp");
            } else {
                /*
                Nejprve se vypíše naázev, adresa, druhy kuchyně, otevírací doba a dny, kdy je restaurace uzavřena.
                 */

                String[] dny = new String[]{"Pondělí:", "Úterý:", "Středa:", "Čtvrtek:", "Pátek:", "Sobota:", "Neděle:"};

                PreparedStatement stm2 = conn.prepareStatement("SELECT * FROM restaurants WHERE id=?");
                stm2.setInt(1, idres);
                rs = stm2.executeQuery();
                rs.next();
                Integer[] times = (Integer[]) rs.getArray("time").getArray();
                String address = rs.getString("adress");


                Integer[] category = null;
                String name = rs.getString("name");
                String description = rs.getString("description");
                if (description == null) description = "";
                String city = rs.getString("city");
                Array categories = rs.getArray("category");
                if (categories != null) category = (Integer[]) categories.getArray();

%>

<div class="border border-dark rounded d-flex flex-column ">
    <div class="form-row align-items-center d-flex ">
        <label class="p-2 "><h2><b><%=name%>
        </b></h2></label>
        <label class=" p-2"><%=city%>
        </label>
        <label class=" p-2"><%=address%>
        </label>
    </div>
    <div class="form-row align-items-center d-flex flex-wrap">
        <%
            String[] types = new String[]{"česká a tradiční", "evropská", "americká", "asijská"};
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
    <label class="p-2"><%=description%>
    </label>
    <%
        for (int i = 0; i < times.length / 2; i++) {
            String so = times[2 * i] / 60 + ":";
            if (times[2 * i] % 60 / 10 == 0) {
                so = so + "0" + times[2 * i] % 60;
            } else {
                so = so + times[2 * i] % 60;
            }
            String sc = times[2 * i + 1] / 60 + ":";
            if (times[2 * i + 1] % 60 / 10 == 0) {
                sc = sc + "0" + times[2 * i + 1] % 60;
            } else {
                sc = sc + times[2 * i + 1] % 60;
            }

    %>
    <div class="form-row align-items-center d-flex ">
        <label class="p-3 "><b><%=dny[i]%> od</b></label>
        <label class=" p-2"><%=so%> do</label>
        <label class=" p-2"><%=sc%>
        </label>
    </div>
    <br>

    <%
        }
        PreparedStatement stm3 = conn.prepareStatement("SELECT date FROM reservations WHERE idres=? AND type=TRUE");
        stm3.setInt(1, idres);
        ResultSet rs3 = stm3.executeQuery();

        Boolean type = true;
        while (rs3.next()) {
            if (type) {
                type = false;
    %>
    <h3> Dny ve které je restaurace uzavřena</h3><br>
    <%
        }
    %>
    <label><%=rs3.getDate("date")%>
    </label><br>
    <%
        }
        conn.close();
/*
Pokud uživateli na minulé straně byl nalezen volný termín pro rezervaci, může ji zde zadáním jména dokončit.
 */
        if (request.getParameter("time") != null) {

            int time = Integer.parseInt(request.getParameter("time"));
            String date = request.getParameter("date");


    %>
    <br>
    <form action="reserve.jsp" method="post">
        <div class="form-row align-items-center d-flex ">
            <label for="name" class="p-2">Na jaké jméno chcete místo zarezervovat:</label>
            <div class="form-row align-items-center d-flex p-3">
                <input type="text" class="p-2" name="name" id="name" placeholder="Vaše jméno" required>
            </div>

        </div>
        <div class="form-row align-items-center d-flex ">
            <input type="hidden" name="ocuppy" value="<%=ocupation%>">
            <input type="hidden" name="time" value="<%=time%>">
            <input type="hidden" name="date" value="<%=date%>">
            <input type="hidden" name="idres" value="<%=idres%>">
            <input type="hidden" name="idus" value="<%=idus%>">

        </div>
        <div class="form-row align-items-center d-flex p-2">
            <button type="submit" class="btn btn-success ">Zarezervovat</button>
        </div>


    </form>
</div>

</body>
</html>
<%
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
