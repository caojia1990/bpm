<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>部署列表</title>
<%
    String path = request.getContextPath();
%>

<!-- css -->
<link href="<%=path%>/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=path%>/resources/css/dashboard.css" rel="stylesheet">
<link href="<%=path%>/resources/css/sticky-footer.css" rel="stylesheet">
<!-- table -->
<link rel="stylesheet" href="<%=path%>/resources/bootstrap-table/bootstrap-table.css">

<!-- datepicker -->
<link href="<%=path%>/resources/bootstrap-datepicker/css/bootstrap-datepicker3.css" rel="stylesheet">

<!-- jquery -->
<script type="text/javascript" src="<%=path%>/resources/jquery/jquery-3.1.1.min.js"></script>
<!-- Bootstrap -->
<script type="text/javascript" src="<%=path%>/resources/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=path%>/resources/tree/bootstrap-treeview.min.js"></script>
<script src="<%=path%>/resources/bootstrap-table/bootstrap-table.js"></script>
<!-- put your locale files after bootstrap-table.js -->
<script src="<%=path%>/resources/bootstrap-table/locale/bootstrap-table-zh-CN.js"></script>

<!-- datepicker -->
<script src="<%=path%>/resources/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="<%=path%>/resources/bootstrap-datepicker/locales/bootstrap-datepicker.zh-CN.min.js"></script>

<script type="text/javascript">
                    $(function() {

                        $('#deployTable').bootstrapTable({
                            
                            columns : [ {
                                field : 'id',
                                title : 'ID'
                            }, {
                                field : 'name',
                                title : '部署名称'
                            }, {
                                field : 'deploymentTime',
                                title : '部署时间'
                            }, {
                                field : 'category',
                                title : '分类'
                            }, {
                                field : 'url',
                                title : '部署url'
                            }, {
                                field : 'tenantId',
                                title : 'tenantId'
                            }, {
                                title : '操作',
                                formatter : operationFormatter
                            } ],
                            url : '<%=path%>/rest/repository/deployments',
            dataField : 'data',
            queryParams : function(params) {
                return {
                    start : params.offset,
                    size : params.limit
                };
            },
            queryParamsType : 'limit',
            pagination : 'true',
            sidePagination : 'server',
            toolbar : '#toolbar'
        });

    });

    
    function operationFormatter(value,row,index) {
        
        var html = '<button type="button" id="undeploy'+row.id+'" class="btn btn-default btn-sm" title="反部署">'
                     + '<i class="glyphicon glyphicon-cloud-download"></i>'
                 + '</button>';
                 
        
      //添加发起事件
        $("#deployTable").off("click","#undeploy"+row.id);
        $("#deployTable").on("click","#undeploy"+row.id,row,function(event){
            undeploy(row.id);
        }); 
        return html;
    }
    
    function undeploy(deploymentId){
    	$.ajax({
            type : "delete",
            url : "<%=path %>/rest/repository/deployments/"+deploymentId,
            dataType: 'json',
            contentType : "application/json;charset=UTF-8",
            success : function(date, status) {
                alert(status);
            }
        });
    }

    
</script>
</head>
<body>

    <%@include file="head.jsp"%>
    <%@include file="footer.jsp"%>

    <div class="container-fluid">
        <div class="row">

            <%@include file="leftMenu.jsp"%>

            <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                <h1 class="page-header">部署列表</h1>

                <div class="table-responsive">
                    <table id="deployTable"</table>

                </div>
            </div>

        </div>

    </div>


    
    <div class="modal fade" id="startModal" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">发起流程</h4>
                </div>
                <div class="modal-body">
                    <form id="form" class="form-horizontal" role="form" >


                        
                    </form>
                </div>
                <!-- <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" onclick="create()">创建</button>
                </div> -->
            </div>
        </div>
    </div>

</body>
</html>
