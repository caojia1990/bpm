<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务管理</title>
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

                        $('#taskTable').bootstrapTable({
                            
                            columns : [ {
                                field : 'id',
                                title : 'ID'
                            }, {
                                field : 'name',
                                title : '任务名称'
                            }, {
                                field : 'assignee',
                                title : '待办人'
                            }, {
                                field : 'createTime',
                                title : '发起时间'
                            }, {
                                field : 'description',
                                title : '描述'
                            }, {
                                field : 'processDefinitionKey',
                                title : '流程定义Key'
                            }, {
                                field : 'completed',
                                title : '是否完成'
                            },{
                                field : 'ended',
                                title : '是否结束'
                            },{
                                field : 'suspended',
                                title : '是否挂起'
                            }, {
                                field : 'processDefinitionUrl',
                                title : '流程定义',
                                formatter : function(value,row,index){
                                    return '<a href="'+value+'"><i class="glyphicon glyphicon-eye-open"/></a>';
                                 }
                            }, {
                                title : '操作',
                                formatter : operationFormatter
                            } ],
                            url : '<%=path%>/rest/runtime/tasks',
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
        var html = '<button type="button" id="work'+row.id+'" class="btn btn-default btn-sm" title="办理">'
                     + '<i class="glyphicon glyphicon-tasks"></i>'
                 + '</button> &nbsp;'
                 
                 + '<button type="button" id="trash'+row.investorNo+'" class="btn btn-default btn-sm" title="删除">'
                     + '<i class="glyphicon glyphicon-trash"></i>'
                 + '</button>';
                 
        $("#taskTable").off("click","#work"+row.id);
        $("#taskTable").on("click","#work"+row.id,row,function(event){
            claimTask(row.id);
        });
        
      //添加删除事件
        $("#taskTable").off("click","#trash"+row.investorNo);
        $("#taskTable").on("click","#trash"+row.investorNo,row,function(event){
            trash(row);
        });
        return html;
    }
    
    function claimTask(taskId){
        
        var param = {
                "action" : "claim",
                "assignee" : "userWhoClaims"
              };
        //签收任务
        $.ajax({
            type : 'post',
            url : '<%=path %>/rest/runtime/tasks/'+taskId,
            dataType: 'text',
            data : JSON.stringify(param),
            contentType : "application/json;charset=UTF-8",
            success : function(date, status) {
                
                //签收成功后打开表单
                $.ajax({
                    type : "get",
                    url : "<%=path %>/rest/form/form-data?taskId="+taskId,
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
                        
                        html += '<div class="form-group">'
                                    +'<button type="button" class="btn btn-default col-sm-2 col-md-2 col-md-offset-6 col-sm-offset-3" data-dismiss="modal">关闭</button>'
                                    +'<button type="button" id="taskBtn" class="btn btn-primary col-sm-2 col-md-2 col-md-offset-1"><i class="icon-play"></i>办理</button>'
                                +'</div>';
                                
                        
                        $("#form").html(html);
                        
                        $("#taskBtn").click(function(){
                            task(processDefId);
                        });
                        
                        $('.datepicker').datepicker({
                            todayBtn: "linked",
                            clearBtn: true,
                            language: "zh-CN",
                            autoclose: true,
                            todayHighlight: true
                        });
                        $("#taskModal").modal('show');
                    }
                });
                
            }
        })
        
        
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
                <h1 class="page-header">任务管理</h1>

                <div class="table-responsive">
                    <table id="taskTable"</table>

                </div>
            </div>

        </div>

    </div>


    <div class="modal fade" id="taskModal" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                    </button>
                    <h4 class="modal-title" id="taskLabel"></h4>
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
