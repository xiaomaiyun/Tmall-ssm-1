<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../include/admin/header.jsp"%>
<%@ include file="../include/admin/navigator.jsp"%>

<title>属性管理</title>

<div class="page-header">
	<h1>
		<a class="m-category-name" href="../admin/category"> </a> <small>
			<i class="ace-icon fa fa-angle-double-right"></i> 属性管理
		</small> <small>
			<button id="addButton" class="btn btn-minier  btn-success">
				<i class="glyphicon glyphicon-plus"></i> 新增
			</button>
		</small>
	</h1>
</div>

<div class="row">
	<div class="col-xs-12">
		<!-- PAGE CONTENT BEGINS -->
		<div class="row">
			<div class="col-xs-12">
				<table id="simple-table" class="table  table-bordered table-hover">
					<thead>
						<tr>
							<th width="41px">ID</th>
							<th width="90px">属性名称</th>
							<th width="94px"></th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
			<!-- /.span -->
		</div>
		<!-- /.row -->
	</div>
	<!-- /.span -->
</div>

<%@ include file="../include/admin/page.jsp"%>

<div id="add-div" class="hide">
	<form id="add-form" class="form-horizontal" role="form"
		enctype="multipart/form-data" method="post">
		<div class="form-group has-success">
			<label class="col-sm-3 control-label no-padding-right" for="name">
				属性名称： </label>
			<div class="col-sm-9">
				<span class="block input-icon input-icon-right"> <input
					type="text" id="name" name="name" placeholder="属性名称"
					class="form-control" /> <i class="ace-icon fa fa-times-circle"
					style="display: none; color: red;"></i> <input type="hidden"
					name="_method" value="post" />
				</span>
			</div>
		</div>
	</form>
</div>

<div id="edit-div" class="hide">
	<form id="edit-form" class="form-horizontal" role="form"
		enctype="multipart/form-data" method="post">
		<div class="form-group">
			<label class="col-sm-3 control-label no-padding-right"
				for="form-input-readonly"> 属性ID： </label>

			<div class="col-sm-9">
				<input readonly="" type="text" class="col-xs-10 col-sm-5"
					id="form-input-readonly" value="" /> </span>
			</div>
		</div>
		<div class="form-group has-success">
			<label class="col-sm-3 control-label no-padding-right" for="name">
				属性名称： </label>
			<div class="col-sm-9">
				<span class="block input-icon input-icon-right"> <input
					type="text" id="name" name="name" class="form-control" /> <i
					class="ace-icon fa fa-times-circle"
					style="display: none; color: red;"></i> <input type="hidden"
					name="_method" value="PUT" />
				</span>
			</div>
		</div>
	</form>
</div>

<div id="delete-div" class="hide">
	<div class="col-sm-9">确认删除吗？</div>
</div>

<%@ include file="../include/admin/footer.jsp"%>

<script type="text/javascript">
jQuery(function($) {
    
    url = window.location.href + 's/';
    getData();

    //分页按钮控制
    $(".pagination").on('click', 'li a', function() {
        var parentDom = $(this).closest('li');
        if(!parentDom.hasClass('disabled') && !parentDom.hasClass('active')) {
            $.cookie('pp-pageParam', $(this).attr('href'));
            getData();
        }
        return false;
    })

    //override dialog's title function to allow for HTML titles
    $.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
        _title: function(title) {
            var $title = this.options.title || '&nbsp;'
            if(("title_html" in this.options) && this.options.title_html == true)
                title.html($title);
            else title.text($title);
        }
    }));

    $("#addButton").on('click', function(e) {
        e.preventDefault();
        
        var dialog = $("#add-div").removeClass('hide').dialog({
            modal: true,
            width: 450,
            title: "<div class='widget-header widget-header-small'><h4 class='smaller'>新增</h4></div>",
            title_html: true,
            buttons: [{
                    text: "取消",
                    "class": "btn btn-minier",
                    click: function() {
                        $("#add-form").clearForm();
                        $(this).dialog("close");
                    }
                },
                {
                    text: "提交",
                    "class": "btn btn-primary btn-minier",
                    click: function() {
                        if(addValidate()) {

                            $("#add-form .form-group").removeClass('has-error').addClass('has-success');
                            $("#add-form").ajaxSubmit({
                                url: url,
                                type: 'post',
                                success: function(data) {
                                    getData();
                                },
                                clearForm: true
                            });

                            $(this).dialog("close");
                        } else {
                            $("#add-form .form-group").removeClass('has-success').addClass('has-error');
                            return false;
                        }
                    }
                }
            ]
        });

    });

    $("#simple-table").on('click', '.m-edit-btn', function(e) {
        e.preventDefault();
        var id = $(this).closest('tr').find('.id').text();
        $("#edit-form input[readonly]").prop('value', id);
        var dialog = $("#edit-div").removeClass('hide').dialog({
            modal: true,
            width: 450,
            title: "<div class='widget-header widget-header-small'><h4 class='smaller'>编辑</h4></div>",
            title_html: true,
            buttons: [{
                    text: "取消",
                    "class": "btn btn-minier",
                    click: function() {
                        $("#edit-form").clearForm();
                        $(this).dialog("close");
                    }
                },
                {
                    text: "提交",
                    "class": "btn btn-primary btn-minier",
                    click: function() {
                        if(editValidate()) {

                            $("#edit-form .form-group").removeClass('has-error').addClass('has-success');
                            $("#edit-form").ajaxSubmit({
                                url: url + id,
                                type: 'post',
                                success: function(data) {
                                    getData();
                                },
                                clearForm: true
                            });
                            
                            $(this).dialog("close");
                        } else {
                            $("#edit-form .form-group").removeClass('has-success').addClass('has-error');
                            return false;
                        }
                    }
                }
            ]
        });

    });

    $("#simple-table").on('click', '.m-delete-btn', function(e) {
        e.preventDefault();
        
        var id = $(this).closest('tr').find('.id').text();
        var dialog = $("#delete-div").removeClass('hide').dialog({
            modal: true,
            width: 450,
            title: "<div class='widget-header widget-header-small'><h4 class='smaller'>删除</h4></div>",
            title_html: true,
            buttons: [{
                    text: "取消",
                    "class": "btn btn-minier",
                    click: function() {
                        $(this).dialog("close");
                    }
                },
                {
                    text: "确认",
                    "class": "btn btn-primary btn-minier",
                    click: function() {
                            $.ajax({
                                url: url + id,
                                type: 'DELETE',
//                              data: {
//                                  _method: 'DELETE'
//                              },
                                success:　function(){
                                    getData();
                                }
                            });
                            $(this).dialog("close");
                    }
                }
            ]
        });

    });
    
    /* $('#image').ace_file_input({
        no_file: 'No File ...',
        btn_choose: 'Choose',
        btn_change: 'Change',
        droppable: false,
        onchange: null,
        thumbnail: false //| true | large
        //whitelist:'gif|png|jpg|jpeg'
        //blacklist:'exe|php'
        //onchange:''
        //
    }); */
    /* $("#add-form input").blur(function() {
        if(addValidate()) {
            $("#add-form .form-group").removeClass('has-error').addClass('has-success');
        } else {
            $("#add-form .form-group").removeClass('has-success').addClass('has-error');
        }
    });
    $("#edit-form input").blur(function() {
        if(editValidate()) {
            $("#edit-form .form-group").removeClass('has-error').addClass('has-success');
        } else {
            $("#edit-form .form-group").removeClass('has-success').addClass('has-error');
        }
    }); */
})
</script>
<script type="text/javascript"> 
	function getData() {
	    clearDataDom();
	    var cid = window.location.pathname.match(/[0-9]+/i)
	    $.get('../admin/categorys/' + cid, function(data, status){
	        $('.m-category-name').text(data.name);
	    })
	    
	    var param = $.cookie('pp-pageParam');
	    if (!param)  param =  "";
	    $.get(url + param, function(data, status) {
	        var list = data.list;
	        for(var i in list) {
	            $('#simple-table tbody').append('<tr> <td class="id">' +
	                list[i].id + '</td>' +
	                '<td>' + list[i].name + '</td>' +
	                '<td><div class="hidden-sm hidden-xs btn-group">' +
	                '<button class="btn btn-xs btn-info m-edit-btn"><i class="ace-icon fa fa-pencil bigger-120"></i></button>' +
	                '<button class="btn btn-xs btn-danger m-delete-btn"><i class="ace-icon fa fa-trash-o bigger-120"></i></button>' +
	                '</div>' +
	                '</td></tr>');
	
	        }
	        pageDom(data);
	    });
	}
	 var validateParam = {
	            rules: {
	                name: {
	                    required: true,
	                    rangelength: [2, 10]
	                }
	            },
	            messages: {
	                name: {
	                    required: "属性名不能为空",
	                    rangelength: "请输入 2 到 10 个 字符"
	                }
	            }
	    }
</script>

<%@ include file="../include/admin/end.jsp"%>