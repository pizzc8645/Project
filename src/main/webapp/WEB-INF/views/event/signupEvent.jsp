<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>

<style type="text/css">
 td {white-space:nowrap;overflow:hidden;text-overflow: ellipsis;}
 table{table-layout:fixed;word-wrap:break-word;}
</style>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel='stylesheet'
	href="${pageContext.request.contextPath}/assets/css/main.css">
<title>Studie Hub</title>

</head>




<script>
	let dataArea = null; //變數放在外面 空值(原始狀態)  放在方法裡 別的方法要用它會找不到 不要讓他被綁住 
	let restname = null;
	let query = null;
	var u_id = "${loginBean.u_id}";
	var userPicString = "${loginBean.pictureString}";   

	window.addEventListener("load", function() {
		//window.addEvenListener 網頁監聽器 
		//當瀏覽器從第一行到最後一行載完畢後才執行 function() 

		
		var logout = document.getElementById("logout");
			logout.onclick = function() {
				var xhr1 = new XMLHttpRequest();
				xhr.open("GET", "<c:url value='/logout.controller' />", true);
				xhr.send();
				xhr.onreadystatechange = function() {
					if (xhr1.readyState == 4 && xhr1.status == 200) {
						var result = JSON.parse(xhr1.responseText);
						if (result.success) {
							alert(result.success);
							top.location = '<c:url value='/' />';
						} else if (result.fail) {
							alert(result.fail);
							top.location = '<c:url value='/' />';
						}
					}
				}
			}

			//universal
		    //如果有登入，隱藏登入標籤
		    var loginHref = document.getElementById('loginHref');
		    var signupHref = document.getElementById('signupHref');
		    var logoutHref = document.getElementById('logoutHref');
		    var userId = document.getElementById('userId');
		    var userPic = document.getElementById('userPic');
			var loginEvent = document.getElementById('loginEvent');
			var loginEvent1 = document.getElementById('loginEvent1');
		    var loginALLEvent1 = document.getElementById('loginALLEvent1');
		    if(u_id){
		    	loginHref.hidden = true;
		    	signupHref.hidden = true;
		    	logoutHref.style.visibility = "visible";	//有登入才會show登出標籤(預設為hidden)
		    	userPic.src = userPicString;	//有登入就秀大頭貼
		    	userId.innerHTML = u_id;
		    	loginEvent.style.display = "block";
		    	loginEvent1.style.display = "block";
		    	loginALLEvent1.style.display = "block";
		    }
			// 有登入才會顯示購物車sidebar
			let cartHref = document.querySelector('#cartHref');
			cartHref.hidden = (u_id)? false : true;
			cartHref.style.visibility = (u_id)? 'visible' : 'hidden';
		//universal
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		dataArea = document.getElementById("dataArea");
		restname = document.getElementById("restname");
		query = document.getElementById("query");
		//抓到 Id 叫 dataArea 能對這個地方做修改 或 對他做監聽事件
		let xhr = new XMLHttpRequest();
		xhr.open("GET", "<c:url value='/signupEventjson/' />"+${signupEvent.a_aid}, true);
		//他會送出請求去/findAll 然後 controller 去接收 /findAll 執行方法
		//說明請求的內容 fales 就是同步 true 就是非同步 
		xhr.send();
		//真正送出請求
		xhr.onreadystatechange = function() {
			//當屬性發生變化的時候執行方法	
			if (xhr.readyState == 4 && xhr.status === 200) {
				console.log(xhr.responseText);

				dataArea.innerHTML = showData(xhr.responseText);
				//執行方法 將 jsoe字串  轉為 jsoe物件 
			}
		};

		query.addEventListener("click", function() {
			//當id= query 的DOM物件被按下後 執行此方法
			let rname = restname.value;
			//取得 id=rname 的DOM物件的值
			if (!rname) {
				alert('請輸入活動名稱,可輸入部分')
				return;
			}

			let xhr2 = new XMLHttpRequest();
			xhr2.open('GET', "<c:url value='/queryEventByName' />?rname=" + rname);
			xhr2.send();
			xhr2.onreadystatechange = function() {
				if (xhr2.readyState == 4 && xhr2.status == 200) {

					console.log(xhr2.responseText);
					
					dataArea.innerHTML = showData(xhr2.responseText);

				}
			}
		});

	});

	function showData(textobj) {

		let obj = JSON.parse(textobj)
		
		let events = obj 

		let segment = "<table >";

		
		
		
			
			segment += "<tr><th>會員帳號</th><th>姓名</th><th>Email</th><th>會員電話</th></tr>"

			for (n = 0; n < events.length; n++) {
				let event = events[n];
				let tmp0 = event.id+"/"+${signupEvent.a_aid};

				segment += "<tr>"
			    segment += "<td>" + event.e_id + "</td>"
				segment += "<td>" + event.e_lastname + event.e_firstname + "</td>"
				segment += "<td>" + event.e_tel + "</td>"
				segment += "<td>" + event.e_email + "</td>"
// 				segment += "<td>" + event.eventInfo.a_uid + "</td>"
				
				segment += "<td><input type='button'value='移除'onclick=if(confirm('是否確定移除("+ event.e_lastname + event.e_firstname + ")'))location='<c:url value = '/deletesignupEvent/"+tmp0+"'/>' /></td>"
				
// 				segment += "<td><img width='100' height='60' src='"+ '<c:url value="/" />' + event.a_picturepath+ "'></td>"
						
// 				segment += "<td><input type='button'value='更新'onclick=\"window.location.href='"+tmp0+"'\" /></td>";

						
			}
						
				segment += "</tr>"
			
		
		        segment += "</table>";

		return segment;
	} 
</script>

<body class="is-preload">
	<!-- Wrapper -->
	<div id="wrapper">
		<!-- Main -->
		<div id="main">
			<div class="inner">
				<%@include file="../universal/header.jsp"%>
				<h2 align='center'>${signupEvent.a_name}的報名表</h2>
				
				<div align="center">
					
					
				</div>
					


				<div1 id='dataArea'>
<!-- 				插入表單位置 -->
				</div1>
<%-- 				<a href="<c:url value='/'/> ">回前頁</a> --%>
			</div>
		</div>

		<!-- Sidebar -->
		<!-- 這邊把side bar include進來 -->
		<%@include file="../universal/sidebar.jsp"%>

	</div>

	<!-- Scripts -->
	<script
		src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/assets/js/browser.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/assets/js/breakpoints.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/util.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>






