package com.group5.springboot.service.question;

import java.util.Map;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.group5.springboot.dao.question.QuestionDao;
import com.group5.springboot.model.question.Question_Info;

@Service
@Transactional
public class QuestionServiceImpl implements QuestionService {
	
	@Autowired
	QuestionDao questionDao;

	////新增試題
	@Override
	public void insertQuestion(Question_Info question_Info) {
		questionDao.insertQuestion(question_Info);
	}
	
	////查詢所有試題
	@Override
	public Map<String, Object> findAllQuestions(){
		return questionDao.findAllQuestions();
	}
	
	////查詢單筆試題
	@Override
	public Question_Info findById(Long q_id){
		return questionDao.findById(q_id);
	}
	
	////刪除單筆試題
	@Override
	public void deleteQuestion(Question_Info question_Info) {
		questionDao.deleteQuestion(question_Info);
	}
	
	////模糊搜尋問題內容
	@Override
	public Map<String, Object> queryByName(String qname) {
		return questionDao.queryByName(qname);
	}
	
	////修改試題
	public void update(Question_Info question_Info) {
		questionDao.update(question_Info);
	}
	
	////送出隨機測驗題目
	@Override
	public Map<String, Object> sendRandomExam() {
		return questionDao.sendRandomExam();
	}

	////送出隨機綜合測驗題目
	@Override
	public Map<String, Object> sendRandomMixExam() {
		return questionDao.sendRandomMixExam();
	}
	
	////送出待審核資料
	@Override
	public Map<String, Object> sendVerifyQuestion() {
		return questionDao.sendVerifyQuestion();
	}
	
	
}
