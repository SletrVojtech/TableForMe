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
<%@ page import="java.time.LocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="menu.jsp" %>
<html>
<head>
    <title>Menu</title>
</head><br><br>
<% /*
Hlavní stránka pro správu restaurace. Pokud nebyl dosud uživatel přihlášen, proběhne kontrola přihlašovacích údajů.
*/
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
                    /*
                    Přihlášení úspěšné.
                     */
                    session.setAttribute("owner", username);

                } else {
                    /*
                    Přihlášení nebylo úspěšné, uživatel musí zadat údaje znovu.
                     */
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
    /*
    Zde proběhne kontrola, zda restaurace již má zadané údaje potřebné k zobrazení uživatelům.
     */
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
    /*
    Zde je formulář pro vypsání rezervací na dané datum. Také proběhne smazání rezervací z minulého dne. Toto není optimální řešení.
    Jelikož ale free hosting na Heroku.com neumožňuje nonstop běžící server, aby mohlo promazávání probíhat pravidelně,
    zdá se mi toto jako nejlepší a nejjednodušší řešení jinak poměrně komplikovaného problému, způsobeného hostingem.
     */
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Date d = Calendar.getInstance().getTime();
    LocalDate l = LocalDate.now();
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DAY_OF_MONTH, 30);
    String date = df.format(d);
    String date2 = df.format(c.getTime());
    c.add(Calendar.DAY_OF_MONTH, -31);
    String date3 = df.format(c.getTime());
    Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
    PreparedStatement stm = conn.prepareStatement("DELETE FROM reservations WHERE date<?;");
    stm.setDate(1, java.sql.Date.valueOf(l));
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
