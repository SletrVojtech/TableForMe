<%@ page import="java.sql.* " %><%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 19:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="head.jsp" %>

<head>
    <title>Kdo u nás všechno je</title>
</head>
<br>

<h3 style="color: black"><b>Výpis všech dostupných restaurací:</b></h3><br><br>

<%
        try {

            Connection conn = DriverManager.getConnection(System.getenv("JDBC_DATABASE_URL"));
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM restaurants;");
            ResultSet rs = stm.executeQuery();
            String[] types = new String[]{"česká a tradiční", "evropská", "americká", "asijská"};
            String name, description, city;
            int id;
            Integer[] category = null;
            while (rs.next()) {
                name = rs.getString("name");
                description = rs.getString("description");
                if (description == null) description = "";
                city = rs.getString("city");
                id = rs.getInt("id");
                Array categories = rs.getArray("category");
                if (categories != null) category = (Integer[]) categories.getArray();


%>

<div class="border border-dark rounded d-flex flex-column ">
    <div class="form-row align-items-center d-flex ">
        <label class="p-2 "><b><%=name%>
        </b></label>
        <label class=" p-2"><%=city%>
        </label>
        <form action="findres.jsp" method="post">
            <div class="ml-auto p-2">
                <input type="hidden" name="id" value="<%=id%>">
                <button type="submit" class="btn btn-success  ">Zjistit obsazenost</button>
            </div>
        </form>
    </div>
    <label class="p-2"><%=description%>
    </label>
    <div class="form-row align-items-center d-flex flex-wrap">
        <%

            if (category != null) {
                for (int i : category
                ) {
        %>
        <label class="p-3" style="color: firebrick"><b><%=types[i]%>
        </b></label>
        <%
                }
            }
        %>

    </div>
</div>
<br><br>
<%


            }


        } catch (Exception e) {
            e.printStackTrace();
        }

%>

</body>
</html>
