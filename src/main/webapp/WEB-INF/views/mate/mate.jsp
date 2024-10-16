<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Document</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="/css/slick.css" type="text/css">
<link rel="stylesheet" href="/css/slick-theme.css" type="text/css">
<link rel="stylesheet" href="/css/main.css" type="text/css">
<link rel="stylesheet" href="/css/mate.css" type="text/css">
<script src="js/matechatting.js" type="text/javascript"></script>
<!--WebSocket 라이브러리 추가 -->
<!--https://cdnjs.com/libraries/sockjs-client -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js" integrity="sha512-1QvjE7BtotQjkq8PxLeF6P46gEpBRXuskzIVgjFpekzFVF4yjRgrQvTG1MTOJ3yQgvTteKAcO7DSZI92+u/yZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- https://cdnjs.com/libraries/stomp.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js" integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="${pageContext.request.contextPath}/js/slick.min.js"></script>

<body>
    <div id="bannerBox">
        <img src="/img/메이트베너.jpg" id="bannerImg"/>
    </div>
         <c:forEach var="uvo" items="${userselect}"><!--유저 정보 가져오기 아이디값은 무조건 줘야 된다.-->
            <input type='hidden' id=usercode value=${uvo.usercode}>
            <input type='hidden' id=gender value=${uvo.gender}>
            <input type='hidden' id=birthdate value=${uvo.birthdate}>
            <input type='hidden' id=mate_popup_date value=${uvo.mate_popup_date}>
            <input type='hidden' id=nickname value=${uvo.nickname}>
         </c:forEach>
    <div class="layout">
            <!-- 중앙 메인 콘텐츠 -->
            <div class="main-content">
                <!-- 필터 -->
                <div class="select-section">
                    <div class="select-box-container">
                        <div class="select-box" id="marathonSelect">
                         
                            <p>내 대회 <span style="white-space: nowrap;overflow: hidden;text-overflow: ellipsis;width: 80px;">&nbsp;▼</span></p>
                            <ul class="dropdown-menu options-list" id="options_list">
                            </ul>
                        </div>
                        <div class="select-box" id="participationCountSelect">
                           참가횟수 <span class="menu_select">&nbsp;▼</span>
                           <ul class="dropdown-menu options-list">
                               <li data-value="1">1~5</li>
                               <li data-value="6">6~10</li>
                               <li data-value="11">11~15</li>
                               <li data-value="16">15회 이상</li>
                           </ul>
                        </div>
                        <div class="select-box" id="mateCountSelect">
                            메이트인원 <span class="menu_select">&nbsp;▼</span>
                            <ul class="dropdown-menu options-list">
                               
                                <li data-value="2">2명</li>
                                <li data-value="3">3명</li>
                                <li data-value="4">4명</li>
                                <li data-value="5">5명</li>
                                <li data-value="6">6명</li>
                                <li data-value="7">7명</li>
                                <li data-value="8">8명</li>
                                <li data-value="9">9명</li>
                                <li data-value="10">10명</li>
                                <li data-value="11">11명</li>
                                <li data-value="12">12명</li>
                                <li data-value="13">13명</li>
                                <li data-value="14">14명</li>
                                <li data-value="15">15명</li>
                                <li data-value="16">16명</li>
                            </ul>
                        </div>
                        <button class="search_match" id="matching" onclick="matching();">&nbsp;매칭하기&nbsp;</button>
                        <button class="search_match" id="accept" onclick="accept();">&nbsp;수락하기&nbsp;</button>
                        <button class="search_match" id="accept_n" onclick="accept_n();">&nbsp;수락취소&nbsp;</button>
                        <button class="search_match" id="out" onclick="match_out();">&nbsp;나가기&nbsp;</button>
                    </div>
                </div>
                <div class="profile-container"></div>
            </div>        <!-- 랭킹 -->
            <div class="ranking-container">
            <div class="ranking">
                <div style="margin-top: 5px;">
                <div class="menu-title">랭킹</div>
                <ul class="rank-list">
                    <c:forEach var="rank" items="${ranking}">
                        <li>
                            <span class="grade" id="grade">${rank.ranking}등</span>
                            <img src="/img/${rank.profile_img}" alt="프로필 이미지" class="profile-img">
                            <div class="rank-info">
                                <span class="rank-name">${rank.nickname}</span>
                                <div class="rank-details">
                                        <span class="runkm">${rank.point_code}</span>
                                     
                                        <span class="crew-name">${rank.crew_name}</span>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
                <div class="more" id="more" onclick="ranking_more();">더보기</div>
            </div>
            </div>
            <!-- 오른쪽 채팅창 -->
                <div id="chatbox">

                    <!-- 대화내용 -->
                    <div id="taMsg">
                        <!-- 여기에 메시지들이 표시됩니다 -->
                    </div>
                    <!-- 메시지입력 -->

                    <div class="chat-input">
                        <input type="text" id="inputMsg" placeholder="채팅을 입력해 주세요">
                        <button id="sendBtn">전송</button>
                    </div>
                </div>
        </div>
    </div>

<!-- 옵션 선택 안내 모달 -->
<div id="optionSelectModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <p>옵션을 선택해주세요</p>
  </div>
</div>

<!-- 매칭 완료 후 선택 모달 -->
<div id="matchCompleteModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <p>매칭이 완료되었습니다.</p>
    <div class="modal-buttons">
       <button id="continueMatching" class="modal-button" data-tooltip="남은 나의 대회에 대한 매칭을 계속 진행합니다.">매칭 계속하기</button>
      <button id="goToMyPage" class="modal-button" data-tooltip="마이페이지에서 매칭된 메이트를 확인하세요.">마이페이지로 이동 </button>    </div>
  </div>
</div>

<!-- 매칭 이용방법 안내 모달 -->
<div id="mateMatchModal" class="mate-modal" style="display:none;">
    <div class="mate-modal-content">
        <!-- 닫기 버튼을 모달 창 내부에 위치시킵니다 -->
        <span class="mate-close-btn">&times;</span>
        <h2>매이트 이용방법 안내</h2>
        <p>매이트 페이지에 오신 것을 환영합니다! 이 페이지에서는 러너들을 위한 매이트 매칭 서비스를 이용할 수 있습니다. 아래 설명을 참고하여 매칭을 원활하게 진행해 주세요.</p>

        <h3 class="highlight-number">1. 매이트 매칭을 위한 필수 조건</h3>
        <p>- 참가하는 대회가 있어야 합니다. 본인이 결제한 대회가 없으면 매칭을 진행할 수 없습니다.<br>
        - "내 대회" 드롭다운 메뉴에서 본인이 참여한 대회를 선택하세요.</p>

        <h3 class="highlight-number">2. 매칭 조건 선택</h3>
        <p>- 참가 횟수와 매칭할 메이트 인원을 선택하세요. 2명부터 16명까지 선택 가능합니다.</p>

        <h3 class="highlight-number">3. 매칭 시작</h3>
        <p>- 매칭 조건을 설정한 후 "매칭하기" 버튼을 누르면 랜덤으로 같은 조건을 선택한 사람들과 매칭이 진행됩니다.<br>
        - 매칭이 진행되면, 선택한 메이트 인원 수만큼 기본 프로필이 표시됩니다.</p>

        <h3 class="highlight-number">4. 매칭 상태 확인 및 채팅</h3>
        <p>- 프로필 주변에 초록색 테두리가 표시되면, 해당 유저가 매칭을 수락한 상태입니다. 모든 유저가 수락해야 매칭이 완료됩니다.<br>
        - 매칭된 방에 입장하면 자동으로 채팅이 연결되어 유저들과 실시간 대화가 가능합니다.</p>

        <h3 class="highlight-number">5. 프로필 사진</h3>
        <p>- 입장한 메이트의 성별은 기본 프로필 사진으로 나타납니다.<br>
        - 자신의 기본 프로필을 클릭하면 런온에서 제공하는 다른 프로필로 바꿀 수 있습니다.</p>

        <h3 class="highlight-number">6. 매칭 완료 및 확인</h3>
        <p>- 매칭된 유저의 정보는 마이페이지에서 확인할 수 있습니다.</p>

        <h3 class="highlight-number">7. 나가기</h3>
        <p>- 매칭원이 마음에 들지 않거나 방을 나가고 싶다면 "수락취소" 또는 "나가기" 버튼을 눌러 매칭 방에서 나올 수 있습니다.</p>

        <!-- RUN ON 로고 -->
        <div style="text-align: center; margin-top: 20px;">
            <img src="/img/logo3.png" alt="RUN ON 로고" style="width: 150px; margin: 20px;">
        </div>

        <div class="mate-modal-footer">
            <label>
                <input type="checkbox" id="mateHide7days" onclick="hide7days()"> 7일간 다시 보지 않기
            </label>
            <label>
                <input type="checkbox" id="mateNeverShow" onclick="neverShow()"> 다시 보지 않기
            </label>
            <button id="mateSaveModalPreferences">확인</button>
        </div>
    </div>
</div>

</body>
<script>
    var clog = console.log;
    var now_personnel, new_personnel, intervalId;
    //매칭룸코드
    var more = 0;
    var cnt  = 0;
    var accept_cnt = 0;
    var update_cnt = 0;
    var day7_check='N';
    var match_yn="${vo.match_yn}";
    var usercode=$('#usercode').val();
    var gender=$('#gender').val();
    var token = localStorage.getItem("Authorization");
    var nickname=$('#nickname').val();
    let socket; // socket 객체
    let stompClient; // stomp를 이용하여 서버와 메시지를 주고 받는다.



    $(document).ready(function() {
        document.getElementById('mateMatchModal').style.display = 'none';
        marathon_code();//내가 결제한 대회리스트 불러오기
        setTimeout(function() {
            if(match_yn>0){
                match_view(match_yn);
                match_view_start(match_yn);
            }
            else start_view();
            popup_yn();//팝업 여부
        }, 200);
        $('.menu_select').text('');
        $('.menu_select').text(' \u25BC');
        setTimeout(function() {
            // 드롭다운을 토글하는 함수
            function toggleDropdown(box) {
                $('.select-box').not(box).removeClass('active'); // 다른 드롭다운을 비활성화
                $(box).toggleClass('active'); // 클릭한 드롭다운을 활성화/비활성화
            }

            // 옵션을 선택하는 함수
            function selectOption(li, box) {
                var selectedText = $(li).text(); // li의 텍스트를 가져옴
                $(box).find('span:first').text(': '+selectedText); // 선택된 텍스트로 span 업데이트
                $(box).removeClass('active'); // 드롭다운 닫기
                // 선택된 li에 따라 다른 동작을 수행
                var selectedValue = $(li).data('value'); // data-value 속성 값 가져오기
                $(box).data('selected-value', selectedValue); // 선택된 값을 box의 data 속성에 저장
                $(box).toggleClass('active'); // 클릭한 드롭다운을 활성화/비활성화
                localStorage.setItem(box.attr('id'), selectedValue); // select-box의 ID를 키로 사용하여 값 저장
            }

            $('.select-box').each(function() {
                var box = $(this);
                var storedValue = localStorage.getItem(box.attr('id')); // 로컬 스토리지에서 값 불러오기
                if (storedValue) {
                    var selectedOption = box.find("li[data-value='" + storedValue + "']");
                    var selectedText = selectedOption.text();
                    box.find('span:first').text(': ' + selectedText); // 선택된 텍스트로 span 업데이트
                    box.data('selected-value', storedValue); // 선택된 값 설정
                }

                // 드롭다운 메뉴 클릭 시 값 선택 처리
                box.find('.dropdown-menu li').on('click', function() {
                    selectOption(this, box); // li 선택 시 텍스트를 업데이트
                });

                // 드롭다운 토글
                box.on('click', function() {
                    toggleDropdown(this);
                });
            });
        }, 200);
        if(match_yn==0){
            $('.menu_select').text('');
            $('.menu_select').text(' \u25BC');
        }
    });


    function match_view_start(match_yn){
        intervalId = setInterval(function() {
            match_view(match_yn);
        }, 2000);
    }


    function match_view(match_yn, flag){//선택한 인원수대로 매칭 자리만들기
        $.ajax({
            url:'/mate/match_view',
            type:'post',
            async: false,
            data:{
                matching_room_code:match_yn //matching_room_code
            },
            success:function(result){
                var length = result[0].buff_n;

                for(var i in  result)
                {
                    if(accept_cnt != result[i].accept_cnt || update_cnt != result[i].update_cnt||flag=='F'){
                        grid_draw(length,result);
                        accept_cnt = result[i].accept_cnt;// Y한사람
                        update_cnt = result[i].update_cnt;// 현재 입장한사람
                    }
                }

                // 매칭 완료가 한 번 표시된 후에는 다시 실행되지 않도록 플래그로 제어
                if(result[0].update_cnt !== 1 && result[0].update_cnt == result[0].accept_cnt) {

                    clearInterval(intervalId);
                    mate_complite();
                    showMatchCompleteModal();
                }

                if(cnt==0){
                    match_view_start(match_yn);
                    cnt++;
                }
            },
            error:function(e){
            }
        });
    }

    function ranking_more(){
        more +=5;
        clog(more);
        if(more>20){$('#more').hide();}
        $.ajax({
            url:'/mate/more',
            type:'post',
            async: false,
            data:{
                more:more
            },success:function(result){
                var list='';
                for (var i in result) {
                    list+='<li>';
                    list+='<span class="grade" id="grade">'+result[i].ranking+'등</span>';
                    list+='<img src="/img/'+result[i].profile_img+'" alt="프로필 이미지" class="profile-img">';
                    list+='<div class="rank-info">';
                    list+='<span class="rank-name">'+result[i].nickname+'</span>';
                    list+='<span class="runkm">'+result[i].point_code+'</span>';

                    list+='<span class="crew-name">'+result[i].crew_name+'</span>';
                    list+='</div>';
                    list+='</li>';
                }
                $('.rank-list').append(list);
            },
            error:function(e){

            }
        });
    }

    function profile_update(num) {//num은 칸에서의 내 위치의 번호
        // 팝업 창의 너비와 높이 설정
        var width = 920;
        var height = 850;

        // 현재 화면의 중앙에 팝업을 배치하기 위한 계산
        var screenLeft = (window.screen.width - width) / 2;   // 가로 중앙
        var screenTop = (window.screen.height - height) / 2;  // 세로 중앙

        // 팝업에 gender와 usercode 값을 쿼리 파라미터로 전달 match_yn

        var popupUrl = '/mate/profileList?gender=' + encodeURIComponent(gender) + '&usercode=' + encodeURIComponent(usercode)+'&match_yn=' + encodeURIComponent(match_yn)+'&num=' + encodeURIComponent(num);

        // 팝업 창을 화면 중앙에 크기 고정으로 엽니다.
        window.open(popupUrl, 'ProfileList',
            'width=' + width + ',height=' + height + ',top=' + screenTop + ',left=' + screenLeft + ',resizable=no,scrollbars=no,menubar=no,status=no,toolbar=no');

    }

    function matching() {
        var marathonValue = $('#marathonSelect').data('selected-value');
        var participationCountValue = $('#participationCountSelect').data('selected-value');
        var mateCountValue = $('#mateCountSelect').data('selected-value');
        clog(marathonValue);
        if(marathonValue === undefined || participationCountValue === undefined || mateCountValue === undefined) {
            // 모달 열기
            showOptionSelectModal(); // 옵션 선택 모달을 호출
            return false;
        }
        $.ajax({
            url:'/mate/matching',
            type:'post',
            async: false,
            data:{
                marathonValue:marathonValue,
                participationCountValue:participationCountValue,
                mateCountValue:mateCountValue
            },success:function(result){
                match_yn=result;
                match_view(result);
            },
            error:function(e){
            }
        });
    }
    function marathon_code(){
        $.ajax({
            url:'/mate/marathon_code',
            type:'post',
            async: false,
            success:function(result){
                var list = '';

                for(var i in result){
                    list += '<li class="marathon_code" data-value="' + result[i].marathon_code + '">' + result[i].marathon_name + '</li>';
                }
                // 옵션 리스트에 항목 추가
                $('#marathonSelect .dropdown-menu').empty(); // 기존 옵션 삭제
                $('#marathonSelect .dropdown-menu').append(list); // 새 옵션 추가
            },
            error:function(e){
                console.error('Error fetching marathon code:', e);
            }
        });
    }


    function match_out(){
        $.ajax({
            url:'/mate/match_out',
            type:'post',
            async: false,
            data:{
                matching_room_code:match_yn
            },
            success:function(result){

                localStorage.removeItem('marathonSelect');
                localStorage.removeItem('participationCountSelect');
                localStorage.removeItem('mateCountSelect');
                localStorage.clear();// 이거 지워야 이용방법 모달안뜸
                location.reload();  // 페이지 새로고침 추가
            },
            error:function(e){
            }
        });
    }

    function mate_complite(){
        $.ajax({
            url:'/mate/mate_complite',
            type:'post',
            async: false,
            data:{
                matching_room_code:match_yn
            },
            success:function(result) {
                localStorage.removeItem('marathonSelect');
                localStorage.removeItem('participationCountSelect');
                localStorage.removeItem('mateCountSelect');
            },
            error:function(e){
            }
        });
    };


    function accept(){
        $.ajax({
            url: '/mate/accept',
            type: 'post',
            async: false,
            data: {
                matching_room_code: match_yn
            },
            success: function(result) {
                match_view(match_yn);
                $('#accept').hide();
                $('#accept_n').show();
            },
            error: function(e) {
                console.error('Error: ', e);
            }
        });
    }

    function accept_n(){
        $.ajax({
            url: '/mate/accept_n',
            type: 'post',
            async: false,
            data: {
                matching_room_code: match_yn
            },
            success: function(result) {

                match_view(match_yn);
                $('#accept').show();
                $('#accept_n').hide();
            },
            error: function(e) {
                console.error('Error: ', e);
            }
        });
    }

    function start_view() {//매칭된 룸이 없으면 기본 빈 8개의 자리 생성
        var list = '';
        $('.profile-container').empty();
        $('#matching').show();
        $('#accept').hide();
        $('#accept_n').hide();
        $('#out').hide();
        for (var i=0; i<8; i++) {
            list+='<div class="profile-box">';
            list+='<div id="profile_img">';
            list+='<img src="/img/user.png" "alt="프로필 1 이미지">';
            list+='</div>';
            list+='<span class="rank-name">&nbsp; </span>';
            list+='<span class="runkm">&nbsp;</span>';
            list+='<span class="crew_name">&nbsp;</span>';
            list+='</div>';
        }
        $('.profile-container').append(list);
    }
    ;
    function grid_draw(length, result) {
        var list = '';

        // 선택한 메이트 인원 + 4의 배수로 맞춘 방 개수 계산
        var total_mates = length;
        var remainder = total_mates % 4;

        // 선택한 메이트 인원 + 4의 배수로 맞추기
        if (remainder !== 0) total_mates += 4 - remainder;
        total_mates = Math.max(8, total_mates); // 최소 8개의 방은 무조건 보여주기

        for (var i = 0; i < result.length; i++) {

            var on = result[i].usercode==usercode? 'onclick="profile_update('+i+');"' : '';
            var gender = result[i].gender=="여"? 'woman':'man' ;
            var no = result[i].b_s=="0"?'0':result[i].b_s;//profile값가저옴
            var img = gender+no;
            //나이 가져오기
            var today = new Date();
            var birthDate = new Date(result[i].birthdate);
            clog('birthDate : '+birthDate);
            var age = (today.getFullYear() - birthDate.getFullYear())+'';
            clog('age : '+age);
            age = age<10? '잼민이' : age[0]+'0대';

            var style = '';
            if(result[i].a_s === 'Y'){  //스타일 및 버튼 제어
                style ="transform: scale(1.05);border-color: #CCFF47;";
                $('#accept').hide();
                $('#accept_n').show();
            }
            else{
                style = '';
                $('#accept').show();
                $('#accept_n').hide();
            }

            list += '<div class="profile-box" '+ on +' style="' + style + '">';
            list += '<div id="profile_img">';

            list += '<img id="img'+i+'" src="/img/' + img + '.png" alt="프로필 1 이미지">';
            list += '</div>';
            list += '<span class="rank-name">' + result[i].nickname + '</span>';
            list += '<span class="age">' + age + '</span>';
            list += '<span class="runkm">' + result[i].tbuf_n + 'Km</span>';
            list += '<span class="crew_name">' + result[i].crew_name + '</span>';
            list += '</div>';
        }

        // 현재 result에 없는, 선택한 메이트 인원에 대해 user.png 표시
        for (var i = result.length; i < length; i++) {
            list += '<div class="profile-box" style="">';
            list += '<div id="profile_img">';
            list += '<img src="/img/user.png" alt="프로필 1 이미지">';
            list += '</div>';
            list += '<span class="rank-name">&nbsp;</span>';
            list += '<span class="runkm">&nbsp;</span>';
            list += '<span class="crew_name">&nbsp;</span>';
            list += '</div>';
        }

        // 나머지 비활성화된 방은 이미지 없이 처리
        for (var i = length; i < total_mates; i++) {
            list += '<div class="profile-box" style="pointer-events: none;">';
            list += '<div id="profile_img" style="background-color: #1e1e1e">'; // 비활성화된 방 처리
            list += '</div>';
            list += '<span class="rank-name">&nbsp;</span>';
            list += '<span class="runkm">&nbsp;</span>';
            list += '<span class="crew_name">&nbsp;</span>';
            list += '</div>';
        }

        // 프로필 컨테이너에 결과 반영
        $('.profile-container').empty();
        $('.profile-container').append(list);

        // 매칭 버튼을 누르면 select 박스 비활성화
        $('.select-box').each(function() {
            // 드롭다운 클릭 자체를 막아줍니다 (클릭 방지)
            $(this).css('pointer-events', 'none');
        });

        // 매칭 버튼을 숨기고 수락, 나가기 버튼 표시
        $('#matching').hide();
        $('#accept').show();
        $('#accept_n').hide();
        $('#out').show();
    }

    // 옵션 선택 안내 모달 열기
    function showOptionSelectModal() {
        var modal = document.getElementById('optionSelectModal');
        modal.style.display = 'block';
    }

    // 매칭 완료 후 모달 열기
    function showMatchCompleteModal() {
        var modal = document.getElementById('matchCompleteModal');
        modal.style.display = 'block';
    }

    // 옵션 선택 모달의 닫기 버튼 클릭 시 모달 닫기
    document.querySelector('#optionSelectModal .close').onclick = function() {
        document.getElementById('optionSelectModal').style.display = 'none';
    };

    // 매칭 완료 모달의 닫기 버튼 클릭 시 모달 닫기
    document.querySelector('#matchCompleteModal .close').onclick = function() {
        document.getElementById('matchCompleteModal').style.display = 'none';
    };


    // 매칭 계속하기 버튼 클릭 시 매칭 완료 모달 닫고 이에를 ajax 안에서 열여야되는뎅
    document.getElementById('continueMatching').onclick = function() {
        window.location.href = '/mate/mate';  //
    };

    // 마이페이지로 이동 버튼 클릭 시 마이페이지로 이동
    document.getElementById('goToMyPage').onclick = function() {
        window.location.href = '/mypage/myHome';  // 마이페이지로 이동
    };

    // 모달 열기
    window.onload = function test3() {
        var Authorization = localStorage.getItem("Authorization");
        if (token !== "" && token !== null) {
            $.ajax({
                url: "/mate/test",
                type: "post",
                data: { Authorization: Authorization },
                success: function (r) {
                    console.log("mate에서 username을 보낸다: " + r);
                }
            });
        }
    }

    // 모달 닫기 버튼
    document.querySelector('.mate-close-btn').onclick = function() {
        document.getElementById('mateMatchModal').style.display = 'none';
    }
    // 모달 닫기 버튼
    document.querySelector('#mateSaveModalPreferences').onclick = function() {
        document.getElementById('mateMatchModal').style.display = 'none';
    }
    // 모달 외부 클릭 시 닫기
    window.onclick = function(event) {
        var modal = document.getElementById('mateMatchModal');
        if (event.target == modal) {
            modal.style.display = 'none';
        }
    }

    function hide7days(){
        var num = $('#mateHide7days').is(':checked')?7:-7;
        $.ajax({
            url: '/mate/hide7days',
            type: 'post',
            async: false,
            data: {
                Authorization: token,
                num: num
            },
            success: function(result) {
            },
            error: function(e) {
                console.error('Error: ', e);
            }
        });
    }


    function neverShow(){
        var num = $('#mateNeverShow').is(':checked')?99999:0;
        clog(num);
        $.ajax({
            url: '/mate/neverShow',
            type: 'post',
            async: false,
            data: {
                Authorization: token,
                num: num
            },
            success: function(result) {
            },
            error: function(e) {
                console.error('Error: ', e);
            }
        });
    }
    function popup_yn(){
        var today = new Date();
        mate_popup_date_select();
        var futureDate = new Date($('#mate_popup_date').val());
        var todayString = today.toISOString().split('T')[0];
        var futureDateString = futureDate.toISOString().split('T')[0];

        if (todayString > futureDateString) {
            document.getElementById('mateMatchModal').style.display = 'block';
        }
        else if (todayString === futureDateString) {
            document.getElementById('mateMatchModal').style.display = 'block';
        }
        else {
            document.getElementById('mateMatchModal').style.display = 'none';
        }
    }

    function mate_popup_date_select(){
        $.ajax({
            url: '/mate/mate_popup_date_select',
            type: 'post',
            async: false,
            data: {
                Authorization: token,
            },
            success: function(result) {
                $('#mate_popup_date').val(result);
            },
            error: function(e) {
                console.error('Error: ', e);
            }
        });
    }

//////////////////////////////////////////////////////////////////////////////////


    $(document).ready(function() {
        // nickname 값을 가져와서 로그로 확인
        var nickname = $('#nickname').val(); // hidden 필드에서 값 가져오기
        console.log("로그인한 사용자의 닉네임: " + nickname);


        // 자동으로 채팅 서버 연결하기
        chatConnection();

        // 서버로 메시지 보내기 (Enter 키)
        $("#inputMsg").keyup(function(event){
            if (event.keyCode === 13) {
                sendMessageFromInput();
            }
        });

        // 서버로 메시지 보내기 (전송 버튼)
        $("#sendBtn").click(function() {
            sendMessageFromInput();
        });

        // 연결 끊기 처리
        $("#disconnectBtn").click(function() {
            sendMessage(usercode, nickname, 'all', nickname + "님이 퇴장하였습니다.");
            if (stompClient != null) {
                stompClient.disconnect();
            }
            socket = null;
            stompClient = null;
            disabledChat();
        });
    });

    // 채팅 서버와 연결하는 함수
    function chatConnection() {
        socket = new SockJS("/chat");
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {
            console.log('WebSocket 연결 성공:', frame);
            setConnected();

            // 서버로 메시지 전송 (닉네임 접속 알림)
            sendMessage(usercode, nickname, 'all', nickname + "님이 접속하였습니다.");

            // 서버에서 받은 메시지를 구독하고 처리
            stompClient.subscribe("/topic/messages", function(receiveMsg) {
                console.log('receiveMsg->',receiveMsg);
                var jsonMsg = JSON.parse(receiveMsg.body);
                console.log("서버에서 수신한 메시지:", jsonMsg); // 수신한 메시지 확인
                showCatMessage(jsonMsg);
            });
        });
    }

    // 메시지를 입력창에서 가져와 서버로 전송하는 함수
    function sendMessageFromInput() {
        var inputMsg = $("#inputMsg").val(); // 입력한 메시지
        if (inputMsg === "") return false; // 빈 메시지 전송 방지

        sendMessage(usercode, nickname, 'all', inputMsg); // 로그인한 회원의 닉네임으로 메시지 전송
        $("#inputMsg").val(''); // 입력창 초기화
    }

    // 서버로 메시지 전송 함수
    function sendMessage(usercode, nickname, recipient, content, add_date) {
        let messageData = {
            usercode: usercode, // 전역 변수 usercode 사용
            nickname: nickname, // 전역 변수 nickname 사용
            recipient: recipient,   // 수신자 정보
            content: content,    // 메시지 내용
            add_date: add_date
        };
        stompClient.debug = null;
        stompClient.send("/message/chat", {}, JSON.stringify(messageData));
    }


    // 서버에서 받은 메시지를 화면에 표시하는 함수
    function showCatMessage(data) {
        console.log("서버에서 받은 메시지:", data); // 수신한 메시지 출력
        // 메시지를 화면에 렌더링하기 위한 HTML 태그 생성
        var tag = '';
        // 내가 보낸 메시지인 경우 (오른쪽에 표시)
        if (data.usercode == usercode) {
            tag += `
        <div class="chat-message">
            <img src="/img/man0.png" alt="프로필 이미지" class="profile-img">
            <div class="message-info">
                <span class="nickname">${data.nickname}</span>
                <p>${data.content}</p>
                <div class="timestamp">${data.add_date}</div>
            </div>
        </div>`;
        } else {
            // 다른 사람이 보낸 메시지인 경우(왼쪽에 표시)
            tag += `
        <div class="chat-message-left">
            <img src="/img/woman0.png" alt="프로필 이미지" class="profile-img">
            <div class="message-info">
                <span class="nickname">${data.nickname}</span>
                <p>${data.content}</p>
                <div class="timestamp-left">${data.add_date}</div>
            </div>
        </div>`;
        }
        // 메시지를 채팅창에 추가
        $("#taMsg").append(tag);

        // 스크롤을 최신 메시지로 자동 이동
        document.getElementById("taMsg").scrollTop = document.getElementById("taMsg").scrollHeight;
    }

    // 채팅 창 비활성화 함수
    function disabledChat() {
        $("#nickname").val("");
        $("#status").html("연결 후 채팅하세요.");
        $("#inputMsg").val("");
        $("#taMsg").html("");
        $("#chatbox").css("display", "none");
    }

    // 서버와 채팅 서버 연결 상태 처리 함수
    function setConnected() {
        // $("#connected").prop('disabled', true); // 채팅 연결하기 비활성화
        // $("#nickname").prop('disabled', true); // 닉네임 입력 비활성화
        $("#status").html(nickname + "님이 접속하였습니다."); // 연결 상태 알림
        $("#chatbox").css("display", "flex"); // 채팅 박스 표시
    }





</script>
