<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>流程发起</title>
    <%String path=request.getContextPath(); %>
    <!-- jquery -->
    <script type="text/javascript" src="<%=path %>/resources/jquery/jquery-3.1.1.min.js"></script>
    <!-- Bootstrap -->
    <script type="text/javascript" src="<%=path %>/resources/bootstrap/js/bootstrap.min.js"></script>
    <link href="<%=path %>/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=path %>/resources/css/dashboard.css" rel="stylesheet">
    <link href="<%=path %>/resources/css/sticky-footer.css" rel="stylesheet">

    <!-- datepicker -->
    <script src="<%=path %>/resources/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
    <script src="<%=path %>/resources/bootstrap-datepicker/locales/bootstrap-datepicker.zh-CN.min.js"></script>
    <!-- datepicker css-->
    <link href="<%=path %>/resources/bootstrap-datepicker/css/bootstrap-datepicker3.css" rel="stylesheet">
  </head>
  <body>

    <%@include file="head.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <%@include file="leftMenu.jsp" %>
        
        <%@include file="startProcessForm.jsp" %>
        
      </div>
    </div>
    
    <%@include file="footer.jsp" %>
  </body>
</html>
