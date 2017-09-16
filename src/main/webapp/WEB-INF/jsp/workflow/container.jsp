<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
  <h1 class="page-header">发起流程</h1>
  
    <script type="text/javascript">
    
       $(function(){
    	   
        	
        	
        });
       
        function test() {
            $.ajax({
                type : "get",
                url : "<%=path %>/rest/form/form-data?processDefinitionId=vacationRequest:1:8",
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
                    $("#activitiModal").modal('show');
                }
            });
        }
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
    
    <div class="alert alert-success" style="height: auto;width: 30%;margin: auto;" >
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <strong>警告！</strong>您的网络连接有问题。
    </div>
    
</div>