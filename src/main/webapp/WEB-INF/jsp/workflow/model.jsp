<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome</title>
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

        $('#modelTable').bootstrapTable({
            columns : [ {
                field : 'name',
                title : '模型名称'
            }, {
                field : 'key',
                title : '模型键'
            }, {
                field : 'category',
                title : '分类'
            }, {
                field : 'version',
                title : '版本号'
            }, {
                field : 'metaInfo',
                title : '元信息'
            }, {
                field : 'deploymentId',
                title : '部署ID'
            }, {
                field : 'id',
                title : 'ID'
            }, {
                field : 'url',
                title : '模型url',
                formatter : function(value,row,index){
                       return '<a href="'+value+'"><i class="glyphicon glyphicon-eye-open"/></a>';
                    }
            }, {
                field : 'deploymentUrl',
                title : '部署url'
            }, {
                field : 'tenantId',
                title : 'tenantId'
            }, {
                title : '操作',
                formatter : operationFormatter
            } ],
            url : '<%=path%>/rest/repository/models',
            detailView : true,
            detailFormatter : function(index, row, element) {
		                return '<img src="'+row.sourceExtraUrl+'"/>';
		            },
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
        var html = '<a href="<%=path%>/modeler.html?modelId='+row.id+'"><button type="button" id="cog'+row.id+'" class="btn btn-default btn-sm" title="设置">'
                      + '<i class="glyphicon glyphicon-cog"></i>'
                 + '</button></a> &nbsp;'
                 
                 +'<button type="button" id="deploy'+row.id+'" class="btn btn-default btn-sm" title="部署">'
                     + '<i class="glyphicon glyphicon-cloud-upload"></i>'
                 + '</button> &nbsp;'
                 
                 + '<button type="button" id="trash'+row.id+'" class="btn btn-default btn-sm" title="删除">'
                     + '<i class="glyphicon glyphicon-trash"></i>'
                 + '</button>';
        //部署
        $("#modelTable").off("click","#deploy"+row.id);
        $("#modelTable").on("click","#deploy"+row.id,row,function(event){
            deploy(row);
        });
        
      //添加删除事件
        $("#investorTable").off("click","#trash"+row.investorNo);
        $("#investorTable").on("click","#trash"+row.investorNo,row,function(event){
            trash(row);
        });
        return html;
    }
    
    function deploy(modelId){
    	
    	$('<div class="alert alert-success" style="height: auto;width: 30%;margin: auto;" >'
    	        +'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
    	          +'<span aria-hidden="true">&times;</span>'
    	        +'</button>'
    	        +'<strong>警告！</strong>您的网络连接有问题。'
    	    +'</div>').alert();
    	
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
                <h1 class="page-header">流程模型设计</h1>

                <div class="table-responsive">
                    <div id="toolbar" class="btn-group">
                        <button type="button" class="btn btn-default" data-toggle="modal"
                            data-target="#addModal" title="创建模型">
                            <i class="glyphicon glyphicon-plus"></i>
                        </button>
                    </div>
                    <table id="modelTable"</table>

                </div>
            </div>

        </div>

    </div>


    <!-- 创建新模型 -->
    <div class="modal fade" id="addModal" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">创建模型</h4>
                </div>
                <div class="modal-body">
                    <form id="addForm" class="form-horizontal" role="form"
                        action="<%=path%>/workflow/model/create" method="post">

                        <div class="form-group">

                            <label for="name" class="col-sm-3 col-md-3 control-label">模型名称</label>
                            <div class="col-sm-8 col-md-8">
                                <input type="text" class="form-control" id="name" name="name"
                                    placeholder="" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="description" class="col-sm-3 col-md-3 control-label">描述</label>
                            <div class="col-sm-8 col-md-8">
                                <textarea class="form-control" rows="3" id="description"
                                    name="description" placeholder=""></textarea>
                            </div>

                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" onclick="create()">创建</button>
                </div>
            </div>
        </div>
    </div>
    
    

</body>
</html>
