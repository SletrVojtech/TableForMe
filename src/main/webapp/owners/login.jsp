<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 25.01.2021
  Time: 11:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="shortcut icon" href="../images/favicon.ico">
    <link rel="stylesheet" href="../css/page.css">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
            integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
          integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">

    <title>Přihlášení pro majitele</title>
</head>
<%
    String err = request.getParameter("err");
    if (err == null) {
        err = "";
    } else if (err.equals("1")) {
        err = "Špatné přihlašovací údaje";
    }

%>
<div class="d-flex justify-content-center">


    <form action="home.jsp" method="post">
        <div class="form-group ">
            <label for="name">Zadejte uživatelské jméno:</label>
            <input type="text" class="form-control" id="name" name="username" placeholder="Uživatelské jmeno"
                   maxlength="20" pattern="[A-Za-z0-9]{3,}">
        </div>

        <%
            //https://www.w3schools.com/tags/att_input_pattern.asp
        %>
        <div class="form-group ">
            <label for="pass">Zadejte heslo:</label>
            <input type="password" class="form-control" id="pass" name="password">
        </div>
        <%=err%><br>
        <button type="submit" class="btn btn-primary">Přihlásit se</button>
    </form>
</div>
</body>

</html>
