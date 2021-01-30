<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 27.01.2021
  Time: 18:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Nové heslo</title>
</head>
<%

    request.setCharacterEncoding("UTF-8");
    String uid = (String) session.getAttribute("admin");
    if (uid == null) {
        response.sendRedirect("/TableForMe2/admin/adminLogin.jsp");
    } else if (request.getParameter("id") == null) {
        response.sendRedirect("/TableForMe2/admin/home.jsp");
    } else {

%>
<body>
<form action="savepass.jsp" method="post">
    <input type="hidden" name="id" value="<%=request.getParameter("id")%>">
    <input type="password" name="pass">
    <button type="submit">Změnit</button>
</form>
</body>
</html>
<%
    }
%>