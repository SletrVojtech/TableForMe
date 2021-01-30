<%@ page import="java.sql.*" %>
<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 25.01.2021
  Time: 8:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin home</title>
</head>
<%
    request.setCharacterEncoding("UTF-8");
    String uid = (String) session.getAttribute("admin");
    if (uid == null) {
        String name = request.getParameter("username");
        if (request.getParameter("username") == null) {
            response.sendRedirect("/TableForMe2/admin/adminLogin.jsp");
        } else {
            String pass = request.getParameter("password");
            try {
                Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
                PreparedStatement stm = conn.prepareStatement("SELECT id FROM admin WHERE username = ? AND password = crypt(?, password);");

                stm.setString(1, name);
                stm.setString(2, pass);
                ResultSet rs = stm.executeQuery();
                if (rs.next()) {
                    session.setAttribute("admin", name);
                } else {
                    //https://www.tutorialspoint.com/how-to-read-request-parameters-passed-in-url-using-jsp
                    response.sendRedirect("/TableForMe2/admin/adminLogin.jsp?err=1");
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }


%>

<body>
<a href="../logout.jsp">Odhlásit se</a> <br>
<a href="restorepass.jsp">resetovat heslo</a> <br>
<a href="addNewPlace.jsp"> Založit novou restauraci</a><br>

</body>
</html>
<%

%>