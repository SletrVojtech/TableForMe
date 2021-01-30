<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 28.01.2021
  Time: 11:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@include file="menu.jsp" %>
<html>
<head>
    <title>Uzavření restaurace na den</title>
</head>
<body><br><br>
<%
    if (uid == null) {
        response.sendRedirect("/TableForMe2/owners/login.jsp");
    } else {


%>
<%
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Date d = Calendar.getInstance().getTime();
    String date = df.format(d);

%>
<form action="dayprocess.jsp" method="post">
    <div class="d-flex justify-content-center">
        <div class="border border-dark rounded d-flex flex-column"
             style="background-color: #DA5151; padding: 5%; color: white">
            <h3>Uzavřít restauraci na den</h3>
            <div class="d-flex flex-row">
                <label for="date" class="p-2">Datum: </label>
                <input type="date" class="p-2 form-control-lg" value="<%=date%>" min="<%=date%>" id="date" name="date"
                       required>
            </div>
            <br>
            <button type="submit" class="btn btn-warning">Uzavřít (nelze již změnit)</button>

        </div>
    </div>
</form>

</body>
</html>
<%
    }
%>