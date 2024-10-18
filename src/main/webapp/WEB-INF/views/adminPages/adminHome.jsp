<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../inc/sidebar.jspf" %>
<link rel="stylesheet" href="/css/adminPages/adminHome.css" type="text/css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/js/adminPages/adminHome.js" type="text/javascript"></script>
<div class="adminContainer">
    <div id="DashboardHead">
        <div id="maintop">
            <div id="menutitle">Dashboard</div>
            <div id="subtitle">Dashboard</div>
        </div>
    </div>
    <div id="DashboardBody">
        <div id="mainmid2">
            <div class="chart2">
                <div class="chartHead">
                    <div class="chartTitle">VISITOR</div>
                    <div class="btnContain">
                        <button id="btn7Days">7일간</button>
                        <button id="btn30Days">주별</button>
                        <button id="btn1Year">월별</button>
                        <button id="btnYearly">연도별</button>
                    </div>
                </div>
                <div class="chartBody">
                    <div id="loinchart">
                        <canvas id="loginChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="chart2">
                <div class="chartHead">
                    <div class="chartTitle">USER ANALYSIS</div>
                </div>
                <div class="chartBody" style="padding: 20px;">
                    <div id="Memchart2">
                        <div id="chartmem"><canvas id="MemChart"></canvas></div>
                        <div id="joinsuser"><div><div>일간가입자</div><div id="lodding1">Lodding</div></div><div><div>월간가입자</div><div id="lodding2">Lodding</div></div></div>
                    </div>
                </div>
            </div>
            <div class="chart2">
                <div class="chartHead">
                    <div class="chartTitle">Latest payment</div>
                    <div class="btnContain">
                        <div id="buttonhidden"></div>
                    </div>
                </div>
                <div class="chartBody">
                    <div id="newPaymentList">
                        <ul>
                            <li>닉네임 총가격 마라톤명 날짜 </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div id="mainmid">
            <div class="chart1">
                <div class="chartHead">
                    <div class="chartTitle">Marathon Info</div>
                </div>
                <div class="chartBody">
                    <div class="marathonchart">
                        <div class="marathons">
                            <canvas id="marathonChart1"></canvas>
                        </div>
                        <div class="marathons">
                            <canvas id="marathonChart2">11</canvas>
                        </div>
                    </div>
                </div>

            </div>
            <div class="chart1">
                <div class="chartHead">
                    <div class="chartTitle">Annual Sales</div>
                </div>
                <div class="chartBody">
                    <div id="annualSalewon">매출액(원)</div>
                    <canvas id="annualSales"></canvas>
                </div>

            </div>
            <div class="chart1">
                <div id="qnahiddenbtn">

                </div>
                <div class="chartBody">
                    <div id="qnanewList">
                        <ul>
                            <li>닉네임 총가격 마라톤명 날짜 </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

