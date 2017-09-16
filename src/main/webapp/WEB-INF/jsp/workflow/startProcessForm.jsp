<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.activiti.engine.form.FormProperty"%>
<%@page import="org.apache.commons.lang.ObjectUtils"%>
<%@page import="org.activiti.engine.form.FormType"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
    <form action="" method="post">

        <c:forEach items="${startFormData.formProperties}" var="fp">
            <c:set var="fpo" value="${fp}" />
            <%  FormType type = ((FormProperty)pageContext.getAttribute("fpo")).getType();
                String[] keys = {"datePattern"};
                for(String key : keys){
                    pageContext.setAttribute(key, ObjectUtils.toString(type.getInformation(key)));
                }  %>
            
            <c:if test="${fp.type.name == 'string' || fp.type.name == 'long'}">
                <label for="${fp.id}">${fp.name}:</label>
                <input type="text" id="${fp.id}" name="${fp.id}" />
            </c:if>
            <c:if test="${fp.type.name == 'date'} ">
                <label for="${fp.id}">${fp.name}:</label>
                <input type="text" id="${fp.id}" name="${fp.id}" class="datepicker"
                data-date-format="${fn:toLowerCase(datePattern)}">
            </c:if>
        </c:forEach>
        <button type="submit" class="btn" ><i class="icon-play"></i>发起流程</button>
    </form>


</div> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
  <h1 class="page-header">发起流程</h1>
  
    <script type="text/javascript">
    
       $(function(){
           
    	   var formProperties =  '${startFormData.formProperties}';
    	   
    	   
    	   var formProperties = JSON.stringify(formProperties);
           
           var html = "";
           $.each(formProperties,function(i,fp){
               console.log(i, fp);
               if(fp.type == 'long' || fp.type == 'string'){
                   html += "<div class='form-group'>"
                               +"<label for='"+fp.id+"' class='col-sm-3 control-label'>"+fp.name+"</label>"
                               +"<div class='col-sm-8'>"
                                   +"<input type='text' class='form-control' id='"+fp.id+"' name='"+fp.id+"'>"
                               +"</div>"
                           +"</div>";
               }else if(fp.type == 'date'){
                   html += "<div class='form-group'>"
                               +"<label for='"+fp.id+"' class='col-sm-3 control-label'>"+fp.name+"</label>"
                               +"<div class='col-sm-8'>"
                                   +"<input type='text' class='form-control datepicker' id='"+fp.id+"' name='"+fp.id+"' data-date-format='"+fp.datePattern+"'>"
                               +"</div>"
                           +"</div>";
               }
           });
           
           html += "<div class='form-group'>"
                       +"<button type='button' class='btn btn-default col-sm-2 col-md-2 col-md-offset-6' data-dismiss='modal'>关闭</button>"
                       +"<button type='submit' class='btn btn-primary col-sm-2 col-md-2 col-md-offset-1'><i class='icon-play'></i>发起流程</button>"
                   +"</div>";
           
           
           $("#form").html(html);
           $('.datepicker').datepicker({
               todayBtn: "linked",
               clearBtn: true,
               language: "zh-CN",
               autoclose: true,
               todayHighlight: true        
           });
           $("#activitiModal").modal('show');
            
        });
       
        <%-- function test() {
            $.ajax({
                type : "get",
                url : "<%=path %>/rest/form/form-data?processDefinitionId=vacationRequest:2:2507",
                dataType: 'json',
                contentType : "application/json;charset=UTF-8",
                success : function(date, status) {
                    
                    
                }
            });
        } --%>
    </script>
    <input class="btn btn-default" type="button" value="请假申请" onclick="test()">
    
    <div class="modal fade" id="activitiModal" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">流程申请</h4>
                </div>
                <div class="modal-body">
                    <form id="form" class="form-horizontal" role="form">


                        
                    </form>
                </div>
                
            </div>
        </div>
    </div>

</div>