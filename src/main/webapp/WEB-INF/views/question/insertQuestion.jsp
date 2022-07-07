<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix='c' uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>

<html>
<head>

<style type="text/css">
   span.error {
	color: red;
	display: inline-block;
	font-size: 5pt;
}
</style>

<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel='stylesheet'
	href="${pageContext.request.contextPath}/assets/css/main.css">
<title>Studie Hub</title>

 <script>
 var u_id = "${loginBean.u_id}";
 var userPicString = "${loginBean.pictureString}";
 
 if(!u_id){
	 alert("必須先登入才能新增試題!");
	 top.location = "<c:url value='/gotologin.controller' />";
 }
 
 window.onload = function(){
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
 }
 
 
	function insertContent() {
	document.getElementById("q_class").value = "日語";
	document.getElementById("q_type").value = "聽力題";
	document.getElementById("q_question").value = "明日、二人で映画に行きたいです。何と言いますか。";
	document.getElementById("q_selectionA").value = "明日、映画に誘いましょう。";
	document.getElementById("q_selectionB").value = "明日、映画を見に行きませんか。";
	document.getElementById("q_selectionC").value = "明日、映画に行きたいそうですよ。";
	document.getElementById("q_selectionD").value = "明日、映画の撮影を行きましょうか。";
	document.getElementById("q_answer").value = "B";
	};
</script>

</head>

<body class="is-preload">

	<!-- Wrapper -->
	<div id="wrapper">

		<!-- Main -->
		<div id="main">
			<div class="inner">
				<%@include file="../universal/header.jsp"%>

<div align="center">
	<br><h2 align='center'>新增試題資料</h2>
	<form:form method="POST"  modelAttribute="Q1" enctype='multipart/form-data'>
 	<Table>
 	<c:choose>
		<c:when test='${question_Info.q_id == null}'>
		    <tr>
		    	<td>&nbsp;</td>
		    	<td>
	   	  		   &nbsp;
	   	  		</td>
		    </tr>
        </c:when>	   
    	<c:otherwise>
	 	 <tr>
	       <td>題目編號：<br>&nbsp;</td>
	   	   <td><form:hidden path='q_id'/>
	   	    	${question_Info.q_id}<br>&nbsp;
	   	   </td>
	    </tr>
       </c:otherwise>   
		</c:choose>  
		
		<tr>  
	     	<td>課程分類：<br>&nbsp;</td>
	        <td>
		       <form:select path="q_class" >
                   <form:option label="請挑選" value="" />
                   <form:options  items="${classList}" />
               </form:select>
               <form:errors path="q_class"  cssClass="error"/>		      
		   </td>
		</tr>  
		
		<tr>   
	     	<td>題目類型：<br>&nbsp;</td>
	        <td>
		       <form:select path="q_type" >
                   <form:option label="請挑選" value="" />
                   <form:options  items="${typeList}" />
               </form:select>
               <form:errors path="q_type"  cssClass="error"/>		      
		   </td>
	   </tr>
		
	   <tr>
	      <td>問題：<br>&nbsp;</td>
	      <td>
	      	<form:input path="q_question"/>	
		      <form:errors path='q_question' cssClass="error"/>
		  </td>
		</tr>  
		
		<tr> 	  
		   <td>選項A：<br>&nbsp;</td>
	   	  <td>
	      	<form:input path="q_selectionA"/>
		      <form:errors path='q_selectionA' cssClass="error"/>
		  </td>
	   </tr>	   
	   
	   
	   	<tr>
	      <td>選項B：<br>&nbsp;</td>
	      <td>
	      	<form:input path="q_selectionB"/>
		      <form:errors path='q_selectionB' cssClass="error"/>
		  </td>
		</tr>
		   
		<tr>  
		   <td>選項C：<br>&nbsp;</td>
	   	  <td>
	      	<form:input path="q_selectionC"/>	
		      <form:errors path='q_selectionC' cssClass="error"/>
		  </td>
	   </tr>	
	   
	   
	  <tr>
	      <td>選項D：<br>&nbsp;</td>
	      <td>
	      	<form:input path="q_selectionD"/>
		      <form:errors path='q_selectionD' cssClass="error"/>
		  </td>
		</tr>
		
		<tr>
	      <td>選項E：<br>&nbsp;</td>
	      <td>
	      	<form:input path="q_selectionE" placeholder="此欄位為多選題選項" />
		  </td>
		</tr>
		
		<tr>   
	     	<td>正解：<br>&nbsp;</td>
	        <td>
		       <form:checkboxes items="${answerList}"  path="q_answer" />
		      <br><form:errors path='q_answer' cssClass="error"/>
		   </td>
	   </tr>		
		
		
	   <tr>
	      <td>題目照片<br>&nbsp;</td>
	      <td>
	   	  	 <form:input path="multipartFilePic" type='file'/>
		      <form:errors path='multipartFilePic' cssClass="error"/>
		  </td>
		</tr>  
		
		
		<tr>  
		   <td>題目音檔：<br>&nbsp;</td>
	   	  <td>
	      	<form:input path="multipartFileAudio" type='file'/>	
		      <form:errors path='multipartFileAudio' cssClass="error"/>
		  </td>
	   </tr>	
	
	<tr>
		<td colspan='4' align='center'>&nbsp;
		<input type='submit' value='送出資料'>
		<input type='button' onclick="insertContent()" value='一鍵輸入'>
		</td>
	</tr>	
	
	
	</Table>
		 
	</form:form>
	
	<br>
<%-- 	<a href="<c:url value='/question.controller/turnQuestionIndex'/>">回前頁</a> --%>
			</div>
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