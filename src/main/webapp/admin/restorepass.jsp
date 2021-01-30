<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 27.01.2021
  Time: 18:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Reset hesla</title>
</head>
<%
    request.setCharacterEncoding("UTF-8");
    String uid = (String) session.getAttribute("admin");
    if (uid == null) {
        response.sendRedirect("adminLogin.jsp");
    } else {
        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT id,name FROM owners");
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
%>
<form action="setpass.jsp" method="post">
    <input type="hidden" name="id" value="<%=rs.getInt("id")%>">
    <button type="submit"><%=rs.getString("name")%>
    </button>

</form>
<br>
<%

        }
    } catch (Exception e) {
        e.printStackTrace();
    }


%>

<body>

</body>
</html>
<%
    }
%>