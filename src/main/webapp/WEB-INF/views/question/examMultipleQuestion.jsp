<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix='c' uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<!-- 僅多選題，倒數計時器待修改 其他未同步修正 -->
<style type="text/css">
   span.error {
	color: red;
	display: inline-block;
	font-size: 5pt;
}

.spinner {
    width: 70px;
    height: 70px;
    background-color: #5b99de;
    margin: 50px auto 50px auto;
  }
  .spin {
    animation: RotatePlane 1.5s infinite ease-in-out;
  }
  .text {
    text-align: center;
    font-weight: bolder;
    font-size: 2rem;
    color: #5b99de;
  }
  @keyframes RotatePlane {
    0%   { transform: perspective(120px) rotateX(0deg) rotateY(0deg); }
    50%  { transform: perspective(120px) rotateX(-180.1deg) rotateY(0deg); }
    100% { transform: perspective(120px) rotateX(-180deg) rotateY(-179.9deg); }
  }
	/*   覆寫套版樣式 */
  input[type="checkbox"] + label:before{
  	border-radius: 100% !important ;
  }

</style>

<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel='stylesheet'
	href="${pageContext.request.contextPath}/assets/css/main.css">

<title>線上測驗區</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
var obj = null; 
var questions = null;			// 全部值
var size = 0;     				// 總題數
var counter = 0;   				// 目前題目
var userChoice = [];			// 存放使用者所有回答
var examResult = [];			// 考試結果


window.addEventListener('load', function(){
	
	var dataArea = document.getElementById("dataArea");
	var next = document.getElementById("next");
	var back = document.getElementById("back");
	var submit =document.getElementById("submit");
	
	
	let xhr = new XMLHttpRequest();
	xhr.open('GET', "<c:url value='/question.controller/sendRandomExam' />", true);
	xhr.onreadystatechange = function(){
		if (xhr.readyState == 4 && xhr.status == 200 ){
			console.log(xhr.responseText);
			dataArea.innerHTML = showData(xhr.responseText);
		}
	};
	xhr.send();
	
	

	next.addEventListener('click', function(){
			var userAnswers = document.getElementsByName("userAnswer"); 
			var userAnswerChecked  = [];	// 存取使用者單題回答
			
			for(var i = 0; i < userAnswers.length; i ++){    //抓取陣列中,被使用者所選取的項目
				if(userAnswers[i].checked){ 
// 					alert(userAnswers[i].value);
					userAnswerChecked.push(userAnswers[i].value);
					}
				}
// 					alert("userAnswerChecked="+ userAnswerChecked);
	 if(userAnswerChecked != ""){  	//使用者有選擇才進判斷

		if(counter < size-2){
			back.style.display = '';
			userChoice.splice(counter, 1, userAnswerChecked.join(""));
			counter += 1;
			
// 			alert("userAnswerChecked=" + userAnswerChecked );
			alert("userChoice=" + userChoice );
			
			var userLastAnswer = userChoice[counter];
			dataArea.innerHTML = showData(xhr.responseText,userLastAnswer);



		}else if(counter == size-2){
			next.style.display = 'none';
			submit.style.display = '';

			userChoice.splice(counter, 1, userAnswerChecked.join(""));
			
			alert("userAnswerChecked=" + userAnswerChecked );
			alert("userChoice=" + userChoice );
			counter += 1;
			var userLastAnswer = userChoice[counter];
			dataArea.innerHTML = showData(xhr.responseText,userLastAnswer);

			}
	}else{
		alert("請先作答！");
	}
		});
		
	
	back.addEventListener('click', function(){
// 		alert("Nowcounter=" + counter );

		var userAnswers = document.getElementsByName("userAnswer"); 
		var userAnswerChecked  = [];	// 存取使用者單題回答
		
		for(var i = 0; i < userAnswers.length; i ++){    //抓取陣列中,被使用者所選取的項目
			if(userAnswers[i].checked){ 
				alert(userAnswers[i].value);
				userAnswerChecked.push(userAnswers[i].value);
				}
			}
				alert("userAnswerChecked="+ userAnswerChecked);
		
		if(counter == size-1){
			next.style.display = '';
			submit.style.display = 'none';

			userChoice.splice(counter, 1, userAnswerChecked.join(""));
			counter -= 1;
// 			alert("ONEcounter=" + counter );
// 			alert("userAnswer=" + userAnswer );
// 			alert("userChoice=" + userChoice );
			var userLastAnswer = userChoice[counter];
			dataArea.innerHTML = showData(xhr.responseText,userLastAnswer);
			
		 }else if(counter > 1 && counter < size-1){

			
				userChoice.splice(counter, 1, userAnswerChecked.join(""));
// 				alert("2counter=" + counter );
// 				alert("userAnswer=" + userAnswer );
// 				alert("userChoice=" + userChoice );
				
				
				counter -= 1;
				var userLastAnswer = userChoice[counter];
				dataArea.innerHTML = showData(xhr.responseText,userLastAnswer);
				
			
		}else if(counter == 1){
			back.style.display = 'none';
				
			userChoice.splice(counter, 1, userAnswerChecked.join(""));

// 			alert("3counter=" + counter );
// 			alert("userAnswer=" + userAnswer );
// 			alert("userChoice=" + userChoice );

			counter -= 1;
			var userLastAnswer = userChoice[counter];
			dataArea.innerHTML = showData(xhr.responseText,userLastAnswer);
			
			
		}else{
			back.style.display = 'none';
			userChoice.splice(counter, 1, userAnswerChecked.join(""));
			dataArea.innerHTML = showData(xhr.responseTex);
			
			}
		});
	
//判斷題目
		submit.addEventListener('click', function(){
			
			if(counter == size-1){
	
				var userAnswers = document.getElementsByName("userAnswer"); 
				// 建立用來判斷是否有選擇資料
				var userAnswer0 = userAnswers;
				//抓取陣列中,被使用者所選取的項目
				for(var i = 0; i < userAnswers.length; i ++){ 
					if(userAnswers[i].checked){ 
						var userAnswer = userAnswers[i].value;
						userAnswers = 'userAnswer is Checked'; 
						}
					}
				
				userChoice.splice(counter, 1, userAnswer);

// 				alert("ONEcounter=" + counter );
// 				alert("userAnswer=" + userAnswer );
// 				alert("userChoice=" + userChoice );
				

			}
			
				
// 				for(var i=0 ; i<size ; i++){
// 			 	if(userChoice[i] == questions[i].q_answer ){
// 					alert("恭喜第" +  Number(i+1) + "題答對" );
// 			 	}
// 			 	else if(userChoice[i] != questions[i].q_answer){
// 					alert("嫩! 第" + Number(i+1) + "題答錯" );
// 						}
// 				 }

			for(var i=0 ; i<size ; i++){
			 	if(userChoice[i] == questions[i].q_answer.replaceAll(",","") ){
// 					examResult.push(true);
					examResult.push("O");

			 	}
			 	else if(userChoice[i] != questions[i].q_answer.replaceAll(",","")){
// 			 		examResult.push(false);
			 		examResult.push("X");

						}
				 }
		
// 				alert(examResult);
		
				dataArea.innerHTML = showResult(examResult);
			
			
			
			
		});
		
//倒數計時
	    var fiveMinutes = 60 * 5,
        display = document.querySelector('#time');
   		 startTimer(fiveMinutes, display);		
	
});

 function showData(textObj,userLastAnswer){
	let status=["","","",""];  	//先判斷使用者已勾選項
	switch(userLastAnswer){
 		case "A":
 		case "AB":
 		case "ABC":
 		case "ABCD":
			status[0]="checked";
		break;
	} 
	switch(userLastAnswer){
 		case "B":
 		case "AB":
 		case "ABC":
 		case "BC":
 		case "BCD":
 			status[1]="checked";
		break;
	}
	switch(userLastAnswer){
 		case "C":
 		case "AC":
		case "ABC":
 		case "ABCD":
		case "BC":
		case "BCD":
 		case "CD":
			status[2]="checked";
		break;
	}
	switch(userLastAnswer){
 		case "D":
 		case "ABCD":
 		case "AD":
 		case "ABD":
 		case "ACD":
 		case "BD":
 		case "BCD":
 		case "CD":
			status[3]="checked";
		break;
	}
	
	obj = JSON.parse(textObj);
	size = obj.size;
	questions = obj.list;
	let segment = "";
	
	if (size == 0){
		segment += "<h4>很抱歉，目前系統無相關試題</h4>";
	} else {
		segment += "<h4>測驗共" + size + "題</h4><br>";
	    
		   	let question = questions[counter];
	   		let number = counter+1;
	     	
		   	segment += "<h4>第&ensp;" + number + "&ensp;題</h4>";
	
	   		if(question.mimeTypePic == null){
		 	   }else{
		   	segment += "<div><img width='400' height='260' src='" + question.q_pictureString + "' ></div>"; 	
		   		};  	
	  		if(question.mimeTypePic == null){
		  	   }else{
		   	segment += "<div><audio controls src='" + question.q_audioString + "' ></div>"; 
	   	   		}; 

			segment += "<h3>問題：" + question.q_question + "</h3><br>"; 
			segment += "<div><input type='checkbox' value='A' name='userAnswer'  id='A'" + status[0] + " /><label for='A'>"+ "A &emsp; " + question.q_selectionA +"</label><br>";
			segment += "<input type='checkbox' value='B' name='userAnswer' id='B'" + status[1] + " /><label for='B'>"+ "B &emsp; " + question.q_selectionB +"</label><br>";
			segment += "<input type='checkbox' value='C' name='userAnswer' id='C'" + status[2] + " /><label for='C'>"+ "C &emsp; " + question.q_selectionC +"</label><br>";
			segment += "<input type='checkbox' value='D' name='userAnswer' id='D'" + status[3] + " /><label for='D'>"+ "D &emsp; " + question.q_selectionD +"</label></div><hr><br>";


	   }
			return segment;
	};

	 //考試結果
	 function showResult(examResult){
			back.style.display = 'none';
			next.style.display = 'none';
			submit.style.display = 'none';

			var correct = 0;
			var wrong = 0;

		   
			for(var i=0 ; i<size ; i++){
			 	if(userChoice[i] == questions[i].q_answer.replaceAll(",","") ){
			 		alert("答對 使用者選擇="+ userChoice[i]);
			 		alert("答案="+questions[i].q_answer.replaceAll(",",""));
			 		correct += 1
			 	}
			 	else if(userChoice[i] != questions[i].q_answer.replaceAll(",","")){
			 		alert("答錯 使用者選擇="+ userChoice[i]);
			 		alert("答案="+questions[i].q_answer.replaceAll(",",""));
			 	 	wrong += 1
						}
				 }

			
			let correctPercent = correct/size*100 ;
			let	segment2  = "<h4>＜測驗結果＞</h4><br>";
			    segment2 += "<div><h5>&emsp;測驗共" + size + "題</h5></div>";
				segment2 += "<div><h5>&emsp;答錯題數："+ wrong +"題，" + "答對率：" + correctPercent + "%</h5></div><br>";
				segment2 += "<table>";
			
				segment2 += "<tr>" ;
////待改成每五題換行				
			    for(n = 0; n < examResult.length ; n++){
				    segment2 += "<th>第"+ Number(n+1) +"題</th>"
			    }
				    segment2 += "</tr><tr>";
			    
			    for(m = 0; m < examResult.length ; m++){
					segment2 += "<td>" + examResult[m] + "</td>"; 
			    }
			 	    segment2 += "</tr></table>";
			 	    
					return segment2; 
	 } 	 

//倒數計時器
	 function startTimer(duration, display) {
		    var timer = duration, minutes, seconds;
		    setInterval(function () {
		        minutes = parseInt(timer / 60, 10);
		        seconds = parseInt(timer % 60, 10);

		        minutes = minutes < 10 ? "0" + minutes : minutes;
		        seconds = seconds < 10 ? "0" + seconds : seconds;

		        display.textContent = minutes + ":" + seconds;

		        if (--timer < 0) {
		            timer = duration;
		        }
		    }, 1000);
		}



</script>


</head>
<body class="is-preload">

	<!-- Wrapper -->
	<div id="wrapper">

		<!-- Main -->
		<div id="main">
			<div class="inner">
				<%@include file="../universal/header.jsp"%>

<div align='center'>
<h2>線上測驗區</h2>

<div id="clock">讀取時間中...</div>
<div>Registration closes in <span id="time">05:00</span> minutes!</div>


<!-- <hr> -->
<%-- <font color='red'>${successMessage}</font>&nbsp; --%>
<!-- <hr> -->
   

<div align='left'  id='dataArea'>
</div>

<div>
<button id='back' style="display: none">上一題</button>
<button id='next' style="display: ''">下一題</button>
&emsp;<button id='submit' style="display: none">提交</button>
</div><br>
<!-- <br> -->
<%-- <br><a href="<c:url value='/question.controller/turnQuestionIndex'/> " >回前頁</a> --%>
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