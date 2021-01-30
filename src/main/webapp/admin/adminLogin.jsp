<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 20.01.2021
  Time: 10:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>
<%
    String err = request.getParameter("err");
    if (err == null) {
        err = "";
    } else if (err.equals("1")) {
        err = "Špatné přihlašovací údaje";
    }

%>
<body>
<div style="text-align: center">
    <h1>Admin Login</h1>
    <form action="home.jsp" method="post" id="loginForm">
        <label for="username">Username:</label>
        <input id="username" name="username"/>
        <br><br>
        <label for="password">Password:</label>
        <input id="password" type="password" name="password"/>
        <br><br>
        <%=err%><br>
        <button type="submit">Login</button>
    </form>
</div>
</body>
</html>
