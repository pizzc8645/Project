package com.group5.springboot.model.chat;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.springframework.stereotype.Component;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group5.springboot.model.user.User_Info;

@Entity
@Table(name = "chat_Info")
@Component
public class Chat_Info {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer c_ID;
	private String c_Date;
	private String c_Class;
	@Column(columnDefinition = "NVARCHAR(255)")
	private String c_Title;
	@Column(columnDefinition = "NVARCHAR(255)")
	private String c_Conts;
	@Column(name = "U_ID", insertable = false, updatable = false)
	private String u_ID;
	
	@JsonIgnore
	@ManyToOne(fetch = FetchType.LAZY) 	
	@JoinColumn(name = "U_ID", referencedColumnName = "U_ID", insertable = true, updatable = true )
	private User_Info user_Info;
	public User_Info getUser_Info() {
		return user_Info;
	}
	public void setUser_Info(User_Info user_Info) {
		this.user_Info = user_Info;
	}
	
	public Integer getC_ID() {
		return c_ID;
	}
	public void setC_ID(Integer c_ID) {
		this.c_ID = c_ID;
	}
	public String getC_Date() {
		return c_Date;
	}
	public void setC_Date(String c_Date) {
		this.c_Date = c_Date;
	}
	public String getC_Class() {
		return c_Class;
	}
	public void setC_Class(String c_Class) {
		this.c_Class = c_Class;
	}
	public String getC_Title() {
		return c_Title;
	}
	public void setC_Title(String c_Title) {
		this.c_Title = c_Title;
	}
	public String getC_Conts() {
		return c_Conts;
	}
	public void setC_Conts(String c_Conts) {
		this.c_Conts = c_Conts;
	}
	public String getU_ID() {
		return u_ID;
	}
	public void setU_ID(String u_ID) {
		this.u_ID = u_ID;
	}

}
