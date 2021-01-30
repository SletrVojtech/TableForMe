<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 28.01.2021
  Time: 9:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@include file="menu.jsp" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<html>
<head>
    <title>Přidání rezervace</title>
</head>
<%
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else {

        Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
        PreparedStatement stm = conn.prepareStatement("SELECT id FROM owners WHERE username = ?;");
        stm.setString(1, uid);
        ResultSet rs3 = stm.executeQuery();
        rs3.next();
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Date d = Calendar.getInstance().getTime();
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.add(Calendar.DAY_OF_MONTH, 30);
        String date = df.format(d);
        String date2 = df.format(c.getTime());
        String err = request.getParameter("err");
        if (err == null) {
            err = "";
        } else if (err.equals("1")) {
            err = "Na daný termín nelze vytvořit rezervaci";
        } else if (err.equals("2")) {
            err = "Rezervace je v tuto dobu zavřena";
        } else if (err.equals("3")) {
            err = "Rezervace je v tuto dobu obsazena";
        }
%>
<br><br>
<form action="checkrese.jsp" method="post">
    <div class="d-flex justify-content-center">
        <div class="border border-dark rounded d-flex flex-column"
             style="background-color: #DA5151; padding: 5%; color: white">
            <div class="d-flex flex-row">
                <label for="number" class="p-2">Počet hostů: <b style="color: white">*</b> </label>
                <input type="number" class="p-2 form-control-sm" max="50" min="1" id="number" name="number" required>
                <label for="name" class="p-2">Na jméno: </label>
                <input type="text" class="p-2 form-control-sm" minlength="2" maxlength="30" id="name" name="name"
                       required>
            </div>
            <div class="d-flex flex-row">
                <label for="date" class="p-2">Datum rezervace: <b style="color: white">*</b></label>
                <input type="date" class="p-2 form-control-sm" value="<%=date%>" min="<%=date%>" max="<%=date2%>"
                       id="date" name="date" required>
                <label for="time" class="p-2">Čas rezervace: <b style="color: white">*</b></label>
                <input type="time" class="p-2 form-control-sm" id="time" name="time" required>
            </div>
            <br>
            <label class="p-2">* - povinné údaje</label>
            <input type="hidden" name="id" value="<%=rs3.getInt("id")%>">

            <label><%=err%>
            </label>
            <button type="submit" class="btn btn-warning">Zadat</button>

        </div>
    </div>
</form>


</body>
</html>
<%
    }
%>