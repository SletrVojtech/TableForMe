<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 25.01.2021
  Time: 11:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="menu.jsp" %>
<html>
<head>
    <title>Menu</title>
</head>
<%
    if (uid == null) {
        String username = request.getParameter("username");
        if (username == null) {
            response.sendRedirect("login.jsp");
        } else {
            String pass = request.getParameter("password");
            try {
                Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
                PreparedStatement stm = conn.prepareStatement("SELECT id FROM owners WHERE username = ? AND password = crypt(?, password);");

                stm.setString(1, username);
                stm.setString(2, pass);
                ResultSet rs = stm.executeQuery();
                if (rs.next()) {
                    session.setAttribute("owner", username);

                } else {
                    response.sendRedirect("login.jsp?err=1");
                }
                conn.close();


            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }
%>
<body>
<%
    uid = (String) session.getAttribute("owner");
    if (uid != null) {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT state FROM owners WHERE username = ?;");

            stm.setString(1, uid);
            ResultSet rs = stm.executeQuery();
            rs.next();
            boolean b = rs.getBoolean("state");
            if (!b) {
                response.sendRedirect("setup.jsp");
            }
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }


%>
<%
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Date d = Calendar.getInstance().getTime();
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DAY_OF_MONTH, 30);
    String date = df.format(d);
    String date2 = df.format(c.getTime());
    c.add(Calendar.DAY_OF_MONTH, -31);
    String date3 = df.format(c.getTime());
    Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
    PreparedStatement stm = conn.prepareStatement("DELETE FROM reservations WHERE date=?;");
    stm.setString(1, date3);
    stm.executeUpdate();
    conn.close();

%>
<form action="printout.jsp" method="post">
    <div class="d-flex justify-content-center">
        <div class="border border-dark rounded d-flex flex-column"
             style="background-color: #DA5151; padding: 5%; color: white">
            <h3>Vypsat rezervace na daný den</h3>
            <div class="d-flex flex-row">
                <label for="date" class="p-2">Datum: </label>
                <input type="date" class="p-2 form-control-lg" value="<%=date%>" min="<%=date%>" max="<%=date2%>"
                       id="date" name="date" required>
            </div>
            <br>
            <button type="submit" class="btn btn-warning">Vypsat</button>

        </div>
    </div>
</form>
</body>
</html>
