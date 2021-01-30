<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 25.01.2021
  Time: 10:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Zpracování záznamu</title>
</head>
<body>
<% request.setCharacterEncoding("UTF-8");
    String uid = (String) session.getAttribute("admin");
    if (uid == null) {
        response.sendRedirect("adminLogin.jsp");
    } else if(request.getParameter("name") == null){
        response.sendRedirect("home.jsp");
        }else{

        try {
            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT id FROM owners WHERE name = ? OR username = ?;");
            stm.setString(1, request.getParameter("name"));
            stm.setString(2, request.getParameter("username"));
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
%>
Zařízení již existuje <%

} else {
    PreparedStatement stm2 = conn.prepareStatement("INSERT INTO owners (name,password,username,state) VALUES (?,crypt(?,gen_salt('bf')),?, FALSE)");
    stm2.setString(1, request.getParameter("name"));
    stm2.setString(2, request.getParameter("password"));
    stm2.setString(3, request.getParameter("username"));
    stm2.executeUpdate();
%>OK<%
        }

    } catch (Exception e) {
        e.printStackTrace();
    }


%>


<br>
<a href="home.jsp">Zpět</a>
</body>
</html>
<%
    }

%>