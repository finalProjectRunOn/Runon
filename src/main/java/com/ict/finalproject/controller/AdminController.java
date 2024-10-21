package com.ict.finalproject.controller;

import com.ict.finalproject.jwt.JWTUtil;
import com.ict.finalproject.service.AdminPagesService;
import com.ict.finalproject.vo.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/adminPages")
public class AdminController {
    @Autowired
    AdminPagesService service;
    @Autowired
    JWTUtil jwtUtil;

    @GetMapping("/adminHome")
    public String admin(Model model){
        return "adminPages/adminHome";

    }
    @GetMapping("memberlist")
    public String memberlist(){

        return "adminPages/memberlist";
    }
    //Members(db)
   @PostMapping("/selectmlist")
   @ResponseBody
   public Map<String, Object> adminPages(
           @RequestParam(value = "page", defaultValue = "1") int page,
           @RequestParam(value = "searchType", required = false) String searchKey,
           @RequestParam(value = "searchValue", required = false) String searchWord,
           @RequestParam(value = "searchType2", required = false) String searchKey2,
           @RequestParam(value = "searchValue2", required = false) String searchWord2,
           @RequestParam(value = "usercode", required = false) int usercode,

           PagingVO pvo) {

       if(searchWord != null){
           if (searchKey.equals("is_disabled") && (searchWord.equals("Y")||searchWord.equals("y"))){
               searchWord="1";
               System.out.println("왔는지 확인");

           }else if (searchKey.equals("is_disabled") &&(searchWord.equals("N")||searchWord.equals("n"))){
               searchWord="0";
           }
       }
       AdminsVO Avo= service.selectAdminRole(usercode);
       Map<String, Object> map = new HashMap<>();
       pvo.setNowPage(page);
       int Record = 15; // 페이지당 레코드 수
       pvo.setOnePageRecord(Record);
       if (searchWord != null && !searchWord.isEmpty()) {
           pvo.setSearchWord(searchWord);
           pvo.setSearchKey(searchKey);
       }
       if (searchKey2 != null && !searchKey2.isEmpty()) {
           pvo.setSearchKey2(searchKey2);
           pvo.setSearchWord2(searchWord2);
       }


       // 검색 여부에 따라 전체 레코드 수 설정
       int totalRecord;
       if (pvo.getSearchWord() != null && !pvo.getSearchWord().isEmpty()) {
           totalRecord = service.getTotalRecordWithSearch(pvo); // 검색된 레코드 수
       }else if(pvo.getSearchKey2() != null && !pvo.getSearchKey2().isEmpty()) {
            totalRecord = service.getTotalRecordWithSearch(pvo);
       }else {
           totalRecord = service.getTotalRecord(); // 전체 레코드 수
       }

       pvo.setTotalRecord(totalRecord);
       int totalPage = (int) Math.ceil((double) totalRecord / Record);
       pvo.setTotalPage(totalPage);
       pvo.setOffset((pvo.getNowPage() - 1) * pvo.getOnePageRecord());

       // 검색 여부에 따라 회원 목록 가져오기
       List<MemberVO> memList;
       if (pvo.getSearchWord() != null && !pvo.getSearchWord().isEmpty()) {
           memList = service.selectUserWithSearch(pvo); // 검색된 회원 목록 조회
       }else if(pvo.getSearchKey2() != null && !pvo.getSearchKey2().isEmpty()) {
           memList = service.selectUserWithSearch(pvo);
       }
       else {
           memList = service.selectAllUser(pvo); // 전체 회원 목록 조회
       }

       map.put("list", memList);
       map.put("pvo", pvo);
       map.put("Avo", Avo);
       return map;
   }

    //정보받아서 엑셀로 뽑기(db)
    @PostMapping("/uListDownload")
    @ResponseBody
    public Map<String,Object> uListDownload(){
        Map<String, Object> map = new HashMap<String, Object>();
        String role ="ROLE_USER";
        List<MemberVO> memList = service.selectMembers(role);
        map.put("list", memList);
        return map;
    }

    //유저상세페이지 db
    @PostMapping("userdetail")
    @ResponseBody
    public Map<String,Object> userdetail(@RequestParam("usercode") int usercode,
                                        @RequestParam("adminusercode")int adminusercode){
        System.out.println(usercode);
        //유저 인적사항
        Map<String,Object> map=new HashMap<String,Object>();
        //유저전적
        List<RecordVO>recordlist=service.getRecord(usercode);
        System.out.println(recordlist);
        MemberVO mvo=service.selectOneUser(usercode);
        //유저가 결제한 내용
        List<AdminPaymentVO> payVo =service.selectInPay(usercode);
        System.out.println(payVo);
        //신고당한횟수확인이랑 해당 신고리스트로 이동
        List<ReportVO> rlist = service.getUserReport(usercode);
        AdminsVO Avo=service.selectAdminRole(adminusercode);
        System.out.println(Avo);
        map.put("mvo", mvo);
        map.put("recordlist", recordlist);
        map.put("rlist", rlist);
        map.put("payVo", payVo);
        map.put("Avo", Avo);
        return map;
    }
    //유저탈퇴
    @PostMapping("/deluser")
    @ResponseBody
    public int deluser(@RequestParam("usercode") int usercode){
        //System.out.println("오는값확인"+usercode);확인
        int result=service.insertAndDel(usercode);

        return result;
    }
    //유저 정지
    @PostMapping("/disableUser")
    @ResponseBody
    public int disableuser(@RequestParam("usercode") int usercode,
                           @RequestParam("disableday")int disableday){
        int result= service.setDisableUserTime(usercode,disableday);

        return result;
    }
    //유저 오정지 풀어주기
    @PostMapping("/enableUser")
    @ResponseBody
    public int enableUser(@RequestParam("usercode")int usercode){

        int result =service.setEnableUser(usercode);

        return result;
    }
    //선택된 인원 엑셀 다운로드
    @PostMapping("/selectExcel")
    @ResponseBody
    public Map<String,Object> selectExcel(@RequestBody Map<String,Object> Rusercodes){
        List<String> usercodes=(List<String>) Rusercodes.get("usercodes");
        List<MemberVO> selectedMembers=service.selectedMembers(usercodes);
        Map<String,Object> map=new HashMap<>();
        map.put("list", selectedMembers);
        return map;


    }
    // 관리자 리스트가기
    @GetMapping("/adminlist")
    public String adminlist(){
       return "adminPages/adminlist";
    }
    // 관리자 리스트 (db)
    @PostMapping("/adminlist")
    @ResponseBody
    public Map<String,Object> adminlist(
            @RequestParam(value = "page",defaultValue = "1")int page,
            @RequestParam(value = "adminSearchType",required = false)String searchKey,
            @RequestParam(value = "adminSearchValue",required = false)String searchWord,
            @RequestParam(value = "usercode",required = false)Integer usercode,
            @RequestParam(value = "adminSearchType2",required = false)String searchKey2,
            @RequestParam(value = "adminSearchValue2",required = false)String searchWord2,
            PagingVO pvo

    ){
        System.out.println(searchKey);
        System.out.println(searchWord);



        if (searchWord != null && !searchWord.isEmpty()) {
            if (searchKey.equals("role")){
                if (searchWord.equals("SUPER_ADMIN")||searchWord.equals("0")||searchWord.equals("SUPER")) {
                    searchWord="0";
                    System.out.println(searchWord);
                }else if (searchWord.equals("ADMIN")||searchWord.equals("1")) {
                    searchWord="1";
                    System.out.println(searchWord);
                }else if (searchWord.equals("MODERATOR")||searchWord.equals("2")||searchWord.equals("MD")) {
                    searchWord="2";
                    System.out.println(searchWord);
                }else if(searchWord.equals("SUPPORT")||searchWord.equals("3")||searchWord.equals("SUP")) {
                    searchWord="3";
                    System.out.println(searchWord);
                }else{
                    searchWord="4";
                }
            }else if (searchKey.equals("permission_edit") ||
                    searchKey.equals("permission_add") ||
                    searchKey.equals("permission_delete")||
                    searchKey.equals("is_disabled")) {
                if (searchWord.equals("Y")||searchWord.equals("y")) {
                    searchWord = "1";
                } else if (searchWord.equals("N")||searchWord.equals("n")) {
                    searchWord = "0";
                }else{
                    searchWord="3";
                }
            }
            pvo.setSearchWord(searchWord);
            pvo.setSearchKey(searchKey);
        }
        if(searchKey2 != null && !searchKey2.isEmpty()) {
            pvo.setSearchKey2(searchKey2);
            pvo.setSearchWord2(searchWord2);

        }


        Map<String, Object> map = new HashMap<>();
       if(usercode!=null) {
           int usercodevlaue=usercode.intValue();
           AdminsVO AdminRole = service.selectAdminRole(usercodevlaue);
           map.put("Avo", AdminRole);

       }


        pvo.setNowPage(page);
        int Record = 15;
        pvo.setOnePageRecord(Record);

        int totalRecord;
        if (pvo.getSearchWord() != null && !pvo.getSearchWord().isEmpty()) {
            totalRecord=service.getSearchAdminTotalRecord(pvo);
        }else if(pvo.getSearchKey2() != null && !pvo.getSearchKey2().isEmpty()) {
            totalRecord=service.getSearchAdminTotalRecord(pvo);
        }
        else{
            totalRecord=service.getAdminTotalRecord();
        }
        pvo.setTotalRecord(totalRecord);
        int totalPage = (int) Math.ceil((double) totalRecord / Record);
        pvo.setTotalPage(totalPage);
        pvo.setOffset((pvo.getNowPage()-1)*pvo.getOnePageRecord());

        List<AdminsVO> adminsList;
        if (pvo.getSearchWord() != null && !pvo.getSearchWord().isEmpty()) {
            adminsList=service.selectAdminWithSearch(pvo);
            System.out.println("확인용");
        }else if(pvo.getSearchKey2() != null && !pvo.getSearchKey2().isEmpty()) {
            adminsList=service.selectAdminWithSearch(pvo);
        }
        else{

            adminsList=service.selectAllAdmin(pvo);


        }

        map.put("list", adminsList);
        map.put("pvo", pvo);
        return map;


    }
    //관리자 정보 엑셀로 담기
    @PostMapping("/AdminListDownload")
    @ResponseBody
    public  Map<String,Object> AdminListDownload(){
       Map<String,Object> map=new HashMap<>();
       String role="ROLE_ADMIN";
       List<MemberVO>list=service.selectMembers(role);
       map.put("list", list);
       return map;
    }
    //관리자 업데이트
    @PostMapping("/AdminRoleUpdate")
    @ResponseBody
    public int AdminRoleUpdate(AdminsVO vo){
        System.out.println(vo);

          service.updateRole(vo);
        return 1;
    }
    //Members에서 관리자 권한체크
    @PostMapping("/RoleCheck")
    @ResponseBody
    public Map<String,Object> RoleCheck(AdminsVO vo){
       System.out.println(vo.getUsercode());
       AdminsVO Avo=service.selectAdminRole(vo.getUsercode());
       System.out.println(Avo);
       Map<String,Object> map=new HashMap<>();
       map.put("Avo", Avo);
       return map;
    }
    //Members에서 유저를 관리자로 승격
    @PostMapping("/roleUp")
    @ResponseBody
    public int roleUp(@RequestParam("usercode")int usercode,AdminsVO Avo,MemberVO mvo){
        Avo.setUsercode(usercode);
        mvo.setUsercode(usercode);
        int result=service.UpdateUser(Avo,mvo);

        return result;
    }
    //Members에서 관리자를 유저로 강등
    @PostMapping("/roleDown")
    @ResponseBody
    public int roleDown(@RequestParam("usercode")int usercode,MemberVO mvo,AdminsVO Avo){
        Avo.setUsercode(usercode);
        mvo.setUsercode(usercode);
        int result = service.roleDown(mvo,Avo);

        return result;
    }
    //신고관리 접속
    @GetMapping("/ReportList")
    public String ReportList(){
        return "adminPages/ReportList";
    }
    //신고관리 db
    @PostMapping("/ReportList")
    @ResponseBody
    public Map<String,Object> ReportLists(
        PagingVO pvo,@RequestParam(value = "usercode",required = false) Integer usercode,
        @RequestParam(value = "page",defaultValue = "1")int page){
        System.out.println("K1"+pvo.getSearchKey2());
        System.out.println("K2"+pvo.getSearchKey());
        System.out.println("V"+pvo.getSearchWord());
        Map<String,Object> map=new HashMap<>();
        if (usercode !=null){
            int usercodevlaue=usercode.intValue();
            AdminsVO AdminRole = service.selectAdminRole(usercodevlaue);
            map.put("Avo", AdminRole);
        }
        pvo.setNowPage(page);
        int Record = 15;
        pvo.setOnePageRecord(Record);
        int totalRecord;
        if(pvo.getSearchWord() != null && !pvo.getSearchWord().isEmpty()) {
            totalRecord=service.getSearchReportRecord(pvo);
        }else if(pvo.getSearchKey2() != null && !pvo.getSearchKey2().isEmpty()) {
            totalRecord=service.getSearchReportRecord(pvo);
        }else{
            totalRecord=service.getReportTotalRecord();
        }
        pvo.setTotalRecord(totalRecord);
        int totalPage = (int) Math.ceil((double) totalRecord / Record);
        pvo.setTotalPage(totalPage);
        pvo.setOffset((pvo.getNowPage()-1)*pvo.getOnePageRecord());
        List<ReportVO> ReportList;
        if (pvo.getSearchWord() != null && !pvo.getSearchWord().isEmpty()) {
            ReportList=service.selectReportWithSearch(pvo);
        }else if(pvo.getSearchKey2() != null && !pvo.getSearchKey2().isEmpty()) {
            ReportList=service.selectReportWithSearch(pvo);
        }else{
            ReportList=service.selectAllReport(pvo);
        }
        map.put("list", ReportList);
        map.put("pvo", pvo);

        return map;
    }

    @PostMapping("/getUserHistory")
    @ResponseBody
    public Map<String,Object> getUserHistory(@RequestParam("period")String period){
        Map<String,Object> map=new HashMap<>();
        List<AllCountVO> CountList= service.getVisitorsByDateRange(period);

        map.put("list", CountList);

        return map;
    }

    @PostMapping("/adminCharts")
    @ResponseBody
    public Map<String,Object> marathonCount(){
        Map<String,Object> map=new HashMap<>();
        List<MarathonCountVO>McountList=service.getCountregistration();

        List<MemCountVO>MemCountList=service.getCountMemlist();
        map.put("MemList",MemCountList);
        map.put("list", McountList);


        return map;
    }
    @PostMapping("/AgeCount")
    @ResponseBody
    public Map<String,Object> AgeCount(@RequestParam( value = "gender",required = false)String gender){
        Map<String,Object> map=new HashMap<>();
        List<AgeCountVO> genderAgeCount=service.GenderAgeCount(gender);
        map.put("GAClist",genderAgeCount);
        return map;
    }
    @PostMapping("/joinsUser")
    @ResponseBody
    public Map<String,Object> JoinsUser(){
        List<JoinsCountVO> JClist= service.JClist();
        Map<String,Object> map=new HashMap<>();
        map.put("JClist",JClist);

        return map;
    }
    @PostMapping("/newPayment")
    @ResponseBody
    public Map<String,Object> NewPayment(@RequestParam(value="usercode",required = false)Integer usercode){
        Map<String,Object> map=new HashMap<>();
        // 완료 System.out.println(usercode);
        if (usercode!=null){
            int usercodevlaue=usercode.intValue();
            AdminsVO Avo=service.selectAdminRole(usercodevlaue);
        // 완료 System.out.println("Avo"+Avo);
            map.put("Avo", Avo);
        }
        List<QnAVO> QnaList=service.getQnaList();
        List<AdminPaymentVO>APaylist=service.getNewPayment();
        map.put("APaylist",APaylist);
        map.put("qnalist",QnaList);
        // 확인완료 System.out.println(QnaList);
        // 확인완료 System.out.println("최근 결제내역확인용"+APaylist);
        return map;
    }
    @PostMapping("/yearsTop5Marathon")
    @ResponseBody
    public Map<String,Object> YearsTop5Marathon(@RequestParam(value = "year",required = false)Integer year){
        Map<String,Object> map=new HashMap<>();
        int yearvlaue=0;
        if (year!=null){
             yearvlaue=year.intValue();

        }
        List<YearsTop5MarathonVO>YT5Mlist=service.getYearsTop5list(yearvlaue);
        System.out.println(YT5Mlist);
        map.put("YT5Mlist",YT5Mlist);
        return map;
    }
    @PostMapping("/amountCharts")
    @ResponseBody
    public Map<String,Object> AmountCharts(){
        Map<String,Object> map=new HashMap<>();
        List<AdminPaymentVO>APcountList=service.getCountAPlist();
        map.put("APlist", APcountList);

        return map;

    }

    @PostMapping("/reportDetail")
    @ResponseBody
    public Map<String,Object>reportDetail(@RequestParam("report_code")int report_code){
        Map<String,Object> map=new HashMap<>();
        return map;
    }
}
