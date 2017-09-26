<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>历史流程</title>
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

                        $('#historyProcessInstanceTable').bootstrapTable({
                            
                            columns : [ {
                                field : 'id',
                                title : '流程实例ID'
                            }, {
                                field : 'businessKey',
                                title : 'businessKey'
                            }, {
                                field : 'processDefinitionId',
                                title : '流程定义ID'
                            }, {
                                field : 'processDefinitionUrl',
                                title : '流程定义URL'
                            }, {
                                field : 'startTime',
                                title : '开始时间'
                            },{
                                field : 'endTime',
                                title : '结束时间'
                            },{
                                field : 'durationInMillis',
                                title : '耗时'
                            }, {
                                field : 'startUserId',
                                title : '发起人'
                            }, {
                                field : 'startActivityId',
                                title : '开始节点'
                            }, {
                                field : 'endActivityId',
                                title : '结束节点'
                            }, {
                                field : 'deleteReason',
                                title : '删除原因'
                            }, {
                                field : 'superProcessInstanceId',
                                title : '父流程实例ID'
                            }, {
                                field : 'url',
                                title : 'url',
                                formatter : function(value,row,index){
                                    return '<a href="'+value+'"><i class="glyphicon glyphicon-eye-open"/></a>';
                                }
                            }, {
                                field : 'variables',
                                title : '流程变量'
                            }, {
                                title : '操作',
                                formatter : operationFormatter
                            } ],
                            url : '<%=path%>/rest/history/historic-process-instances',
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
                 
                 +'<button type="button" id="cog'+row.investorNo+'" class="btn btn-default btn-sm" title="部署">'
                     + '<i class="glyphicon glyphicon-cloud-upload"></i>'
                 + '</button> &nbsp;'
                 
                 + '<button type="button" id="trash'+row.investorNo+'" class="btn btn-default btn-sm" title="删除">'
                     + '<i class="glyphicon glyphicon-trash"></i>'
                 + '</button>';
                 
        $("#investorTable").off("click","#cog"+row.investorNo);
        $("#investorTable").on("click","#cog"+row.investorNo,row,function(event){
            config(row);
        });
        
      //添加删除事件
        $("#investorTable").off("click","#trash"+row.investorNo);
        $("#investorTable").on("click","#trash"+row.investorNo,row,function(event){
            trash(row);
        });
        return html;
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
                <h1 class="page-header">历史流程</h1>

                <div class="table-responsive">
                    <table id="historyProcessInstanceTable"</table>

                </div>
            </div>

        </div>

    </div>


</body>
</html>
