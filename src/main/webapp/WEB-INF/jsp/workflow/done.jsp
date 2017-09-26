<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>已办任务</title>
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

                        $('#doneTable').bootstrapTable({
                            
                            columns : [ {
                                field : 'id',
                                title : 'ID'
                            }, {
                                field : 'name',
                                title : '任务名称'
                            }
                            , {
                                field : 'owner',
                                title : '发起人'
                            }, {
                                field : 'assignee',
                                title : '处理人'
                            }, {
                                field : 'startTime',
                                title : '发起时间'
                            }, {
                                field : 'endTime',
                                title : '结束时间'
                            }, {
                                field : 'claimTime',
                                title : '签收时间'
                            }, {
                                field : 'taskVariables',
                                title : '任务变量'
                            },{
                                field : 'processVariables',
                                title : '流程变量'
                            }, {
                                title : '操作',
                                formatter : operationFormatter
                            } ],
                            url : '<%=path%>/rest/history/historic-task-instances',
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
        var html = '<button type="button" id="work'+row.id+'" class="btn btn-default btn-sm" title="详情">'
                     + '<i class="glyphicon glyphicon-eye-open"></i>'
                 + '</button> &nbsp;'
                 
                 + '<button type="button" id="trash'+row.investorNo+'" class="btn btn-default btn-sm" title="删除">'
                     + '<i class="glyphicon glyphicon-trash"></i>'
                 + '</button>';
                 
        $("#doneTable").off("click","#work"+row.id);
        $("#doneTable").on("click","#work"+row.id,row,function(event){
            doneTask(row.id);
        });
        
      //添加删除事件
        $("#doneTable").off("click","#trash"+row.investorNo);
        $("#doneTable").on("click","#trash"+row.investorNo,row,function(event){
            trash(row);
        });
        return html;
    }
    
    function doneTask(taskId){
        
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
                        html += '<div class="form-group">'
                                    +'<label for="'+fp.id+'" class="col-sm-3 control-label">'+fp.name+'</label>'
                                    +'<div class="col-sm-5">'
                                        +'<input type="text" class="form-control" id="'+fp.id+'" name="'+fp.id+'" value="'+fp.value+'" readonly>'
                                    +'</div>'
                                +'</div>';
                    }else if(fp.type == 'date'){
                        html += '<div class="form-group">'
                                    +'<label for="'+fp.id+'" class="col-sm-3 control-label">'+fp.name+'</label>'
                                    +'<div class="col-sm-5">'
                                        +'<input type="text" class="form-control datepicker" id="'+fp.id+'" name="'+fp.id+'" value="'+fp.value+'" data-date-format="'+fp.datePattern+'" readonly>'
                                    +'</div>'
                                +'</div>';
                    }
                });
                
                html += '<div class="form-group">'
                            +'<button type="button" class="btn btn-default col-sm-2 col-md-2 col-md-offset-6 col-sm-offset-3" data-dismiss="modal">关闭</button>'
                        +'</div>';
                        
                
                $("#form").html(html);
                
                $('.datepicker').datepicker({
                    todayBtn: "linked",
                    clearBtn: true,
                    language: "zh-CN",
                    autoclose: true,
                    todayHighlight: true
                });
                $("#taskModal").modal('show');
            }//查询任务表单回调函数
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
                <h1 class="page-header">已办任务</h1>

                <div class="table-responsive">
                    <table id="doneTable"</table>

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
