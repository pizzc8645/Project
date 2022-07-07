package com.group5.springboot.service.question;

import java.util.Map;

import org.springframework.stereotype.Service;

import com.group5.springboot.model.question.Question_Info;

@Service
public interface QuestionService {

	////新增試題
	public void insertQuestion(Question_Info question_Info) ;
	
	////查詢所有試題
	public Map<String, Object> findAllQuestions();

	////查詢單筆試題
	public Question_Info findById(Long q_id);
	
	////刪除單筆試題
	public void deleteQuestion(Question_Info question_Info);
	
	////模糊搜尋問題內容
	Map<String, Object> queryByName(String qname);
	
	////修改試題
	public void update(Question_Info question_Info);
	
	////送出隨機測驗題目
	public Map<String, Object> sendRandomExam();
	
	////送出隨機綜合題測驗題目
	public Map<String, Object> sendRandomMixExam();

	////回傳待審核資料
	public Map<String, Object> sendVerifyQuestion();
	
}
