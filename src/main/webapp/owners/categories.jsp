<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="menu.jsp" %>

<head>
    <title>Druhy kuchyně</title>
</head>
<br><br>
<%
    if (uid == null) {
        response.sendRedirect("/TableForMe2/owners/login.jsp");
    } else {


%>

<div style="text-align: center">
    <form action="savecategories.jsp" method="post">
        <input type="checkbox" id="0" name="0" value="0">
        <label for="0">Česká a tradiční kuchyně</label><br>
        <input type="checkbox" id="1" name="0" value="1">
        <label for="1">Evropská kuchyně</label><br>
        <input type="checkbox" id="2" name="0" value="2">
        <label for="2">Americká kuchyně</label><br>
        <input type="checkbox" id="3" name="0" value="3">
        <label for="3">Asijská kuchyně</label><br>
        <button type="submit" class="btn btn-primary">Zaznamenat</button>
    </form>

</div>
</body>
</html>
<%
    }
%>