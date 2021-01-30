<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 15:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="menu.jsp" %>
<%@ page import="java.sql.*" %>
<head>
    <title>Popisek restaurace</title>
</head>
<br><br>
<%
    /*
    Pro zaujmutí zákazníka, má restauratér možnost přidání popisku restaurace. Pokud jej vytvářel již dříve,
     načte se mu původní varianta, kterou může kdykoli upravit.
     */
    if (uid == null) {
        response.sendRedirect("login.jsp");

    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT description FROM restaurants JOIN owners ON restaurants.id = owners.id WHERE owners.username=?; ");
            stm.setString(1, uid);
            ResultSet rs = stm.executeQuery();
            rs.next();
            String des = rs.getString("description");
            if (des == null) des = "";
            conn.close();


%>
<div style="text-align: center">
    <form action="savedescription.jsp" method="post">
        <label for="description">Zde zadejte popisek Vaší restaurace:</label><br>
        <p>K dispozici máte 250 znaků, diky kterým můžete jednoduše zaujmout potenciální zákazníky</p><br>
        <textarea maxlength="250" id="description" name="description" rows="5" cols="50"
                  required><%=des%></textarea><br><br>
        <button type="submit" class="btn btn-primary">Zaznamenat</button>
    </form>
</div>

</body>
</html>
<% } catch (Exception e) {
    e.printStackTrace();
}
}

%>