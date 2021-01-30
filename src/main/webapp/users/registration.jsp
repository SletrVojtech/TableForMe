<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 17:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="head.jsp" %>
<head>

    <title>Registrace</title>
</head>
<%
    String err = request.getParameter("err");
    if (err == null) {
        err = "";
    } else if (err.equals("1")) {
        err = "Zadaná hesla se neshodují";
    } else if(err.equals("2")){
        err = "Uživatel s tímto jménem již existuje";
    }

%>

<div class="d-flex justify-content-center">


    <form action="makeregistration.jsp" method="post">
        <div class="form-group ">
            <label for="name">Zadejte uživatelské jméno:</label>
            <input type="text" class="form-control" id="name" name="name" placeholder="VelkyHladovec" maxlength="20"
                   pattern="[A-Za-z0-9]{3,}">
        </div>

        <%
            //https://www.w3schools.com/tags/att_input_pattern.asp
        %>
        <div class="form-group ">
            <p>Heslo musí obsahovat 8-15 znaků včetně alespoň jedné číslice, malého a velkého písmene</p>
            <label for="pass">Zadejte heslo:</label>
            <input type="password" class="form-control" id="pass" name="pass" minlength="8" maxlength="15"
                   pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}">
        </div>
        <div class="form-group ">
            <label for="pass2">Zadejte heslo znovu:</label>
            <input type="password" class="form-control" id="pass2" name="pass2" minlength="8" maxlength="15"
                   pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}">
        </div>
        <%=err%><br>
        <button type="submit" class="btn btn-primary">Zaregistrovat se</button>
    </form>
</div>
</body>
</html>
