<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../inc/sidebar.jspf" %>
<link rel="stylesheet" href="/css/adminPages/adminlist.css" type="text/css">
<script src="/js/adminPages/adminlist.js" type="text/javascript"></script>
<link rel="stylesheet" href="/css/adminPages/memberlist.css" type="text/css">


    <div id="memlistbody">
        <div>
            <div id="maintop">
                <div id="menutitle">Admins</div>
                <div id="subtitle">관리자 정보와 권한을 관리합니다.</div>
            </div>
        </div>
        <div id="mainmid">
            <div>
                <form>
                    <div id="checkboxlist" style="min-width:170px; max-width: 249px;">
                        <button type="button" class="clickbox" onclick="blockhidden()">권한수정</button>
                        <button type="button" class="clickbox" onclick="checkAll()">저장</button>
                        <button type="button" class="clickbox" onclick="selectExcel()">취소</button>
                    </div>
                    <div id="searchbar">
                        <select class="form-select" id="searchvalue" name="searchvalue">
                            <option value="username">
                                아이디
                            </option>
                            <option value="name">
                                이름
                            </option>
                            <option value="tel">
                                핸드폰번호
                            </option>
                            <option value="is_disabled">
                                정지여부
                            </option>
                        </select>
                        <div>
                            <input type="text" id="searchtext" name="searchtext" onkeydown="enterKey(event)" />
                            <div type="button" id="searchbutton" class="btn btn-m search" onclick="searchbutton()">
                                <i class="fa-solid fa-magnifying-glass fa-2x"></i>
                            </div>
                        </div>
                    </div>

                </form>
                <div style="margin: auto 0"><input type="button" value="전체유저정보받기" onclick="excelDownload()"/></div>
            </div>
        </div>
        <div id="memlistbottom">
            <div class="AdminFavMain">
                <div id='userList'></div>
            </div>
            <ul class="pagination justify-content-center">
            </ul>
            <div class="box_rightType1">
            </div>
        </div>
    </div>
