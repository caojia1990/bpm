<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程列表</title>
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

                        $('#processTable').bootstrapTable({
                            
                            columns : [ {
                                field : 'id',
                                title : 'ID'
                            }, {
                                field : 'key',
                                title : 'KEY'
                            }, {
                                field : 'name',
                                title : '流程定义名称'
                            }, {
                                field : 'category',
                                title : '分类'
                            }, {
                                field : 'version',
                                title : '版本号'
                            }, {
                                field : 'description',
                                title : '描述'
                            },{
                                field : 'deploymentId',
                                title : '部署ID'
                            }, {
                                field : 'resource',
                                title : '流程文件',
                                formatter : function(value,row,index){
                                    return '<a href="'+value+'"><i class="glyphicon glyphicon-eye-open"/></a>';
                                 }
                            }, {
                                field : 'diagramResource',
                                title : '流程图',
                                formatter : function(value,row,index){
                                       return '<a href="'+value+'"><i class="glyphicon glyphicon-picture"/></a>';
                                    }
                            }, {
                                field : 'deploymentUrl',
                                title : '部署url'
                            }, {
                                field : 'startFormDefined',
                                title : '自定义表单'
                            }, {
                                title : '操作',
                                formatter : operationFormatter
                            } ],
                            url : '<%=path%>/rest/repository/process-definitions',
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

    function create() {
        $('#addForm').submit();
    }
    
    function operationFormatter(value,row,index) {
        
        var html = '<a href="<%=path%>/modeler.html?modelId='+row.id+'"><button type="button" id="cog'+row.investorNo+'" class="btn btn-default btn-sm" title="设置">'
                      + '<i class="glyphicon glyphicon-cog"></i>'
                 + '</button></a> &nbsp;'
                 
                 + '<button type="button" id="start'+escapse(row.id)+'" class="btn btn-default btn-sm" title="发起流程">'
                     + '<i class="glyphicon glyphicon-play"></i>'
                 + '</button>';
                 
        
      //添加发起事件
        $("#processTable").off("click","#start"+escapse(row.id));
        $("#processTable").on("click","#start"+escapse(row.id),row,function(event){
            startModal(row.id);
        }); 
        return html;
    }
    
    function escapse(str){
        var reg = new RegExp(":","g");
        return str.replace(reg,"0");
    }
    
    function startModal(processDefId){
        
        $.ajax({
            type : "get",
            url : "<%=path %>/rest/form/form-data?processDefinitionId="+processDefId,
            dataType: 'json',
            contentType : "application/json;charset=UTF-8",
            success : function(date, status) {
                
                var formProperties = date.formProperties;
                
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
                $("#startModal").modal('show');
            }
        });
    }
    
    /* Start a process instance */
    function start(processDefId){
        
        $.ajax({
            type : "get",
            url : "<%=path %>/rest/form/form-data?processDefinitionId="+processDefId,
            dataType: 'json',
            contentType : "application/json;charset=UTF-8",
            success : function(date, status) {
                
                $("#startModal").modal('hide');
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
                <h1 class="page-header">已部署流程列表</h1>

                <div class="table-responsive">
                    <table id="processTable"</table>

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
                    <form id="form" class="form-horizontal" role="form">


                        
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
