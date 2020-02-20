<!--
* @author Dongwook Kim <dongwook.kim1211@worksmobile.com>
* @file board.jsp
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>BLOCK BOARD</title>
    <script src="https://use.fontawesome.com/releases/v5.12.1/js/all.js"
            data-auto-replace-svg="nest"></script>
    <link rel="stylesheet" href="/webjars/bootstrap/4.4.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/static/css/boardstyle.css">
    <link href="https://fonts.googleapis.com/css?family=Noto+Sans+JP|Roboto&display=swap"
          rel="stylesheet">
    <style>
        body {
            font-family: "Roboto", sans-serif;
            font-family: 'Noto Sans JP', sans-serif;
        }
    </style>
    <script src="/static/js/util/data.js"></script>
</head>

<body>

<nav class="navbar navbar-expand navbar-dark bg-success">
    <a class="navbar-brand" id="companyInfo" href="JavaScript:window.location.reload()"
       value="${companyID}">${companyName}</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse"
            data-target="#navbarsExample02"
            aria-controls="navbarsExample02" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarsExample02">


        <ul class="navbar-nav mr-auto ">
            <c:if test="${userType=='관리자'}">
                <li class="nav-item active">
                    <a class="nav-link" id='add_board_btn'
                       style="cursor:pointer" data-toggle="modal" data-target="#addBoardModal">게시판
                        추가</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" id='changeBoardsNameBtn' data-toggle="modal"
                       data-target="#changeBoardNameModal"
                       onclick="javascript:clickchangeBoardBtn(this)" style="cursor:pointer">게시판
                        이름변경</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" id='deleteBoardsBtn' data-toggle="modal"
                       data-target='#deleteBoardModal'
                       onclick="javascript:clickDeleteBoardBtn(this)"
                       style="cursor:pointer">게시판 삭제</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" id='addUsersBtn' data-toggle="modal"
                       data-target='#addUserModal'
                       style="cursor:pointer">회원 추가</a>
                </li>
            </c:if>
            <li class="nav-item dropdown"
                    <c:if test="${userType!='관리자'}">
                        style = "visibility: hidden"
                    </c:if>
            >
                <a class="nav-link dropdown-toggle active" href="#" id="dropdown03"
                   data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false">사용중인 기능</a>
                <div class="dropdown-menu" id="fuctionListContainer"
                     aria-labelledby="dropdown03">
                    <c:if test="${userType=='관리자'}">
                        <a class="dropdown-item text-success" id='changeFuncBtn' data-toggle="modal"
                           data-target="#changeFunctionModal"
                           onclick="javascript:changeFunction(this)" style="cursor:pointer"><strong>기능
                            변경</strong></a>
                        <div class="dropdown-divider"></div>
                    </c:if>
                    <c:forEach items="${functionInfoList}" var="functionList"
                               varStatus="status">
                        <c:if test="${functionList.functionOn}">
                            <a class="dropdown-item" id=functionAble${functionList.functionID}
                               value=on> ${functionList.functionName} </a>
                        </c:if>
                        <c:if test="${!(functionList.functionOn)}">
                            <a class="dropdown-item d-none"
                               id=functionAble${functionList.functionID}
                               value=off> ${functionList.functionName}</a>
                        </c:if>
                    </c:forEach>
                </div>

            </li>
        </ul>

        <!--현재 기능 사용 여부 현황 템플릿-->
        <script id="functionList-template" type="text/x-handlebars-template">
            <a class="dropdown-item text-success" id='changeFuncBtn' data-toggle="modal"
               data-target="#changeFunctionModal"
               onclick="javascript:changeFunction(this)"
               style="cursor:pointer"><strong>기능 변경</strong></a>
            <hr>
            {{#functions}}
                {{#isAbleFunction}}
                    <a class="dropdown-item d-none" id='functionAble{{functionID}}'
                       value='off'>{{functionName}}</a>
                {{else}}
                    <a class="dropdown-item" id='functionAble{{functionID}}'
                       value='on'>{{functionName}}</a>
                {{/isAbleFunction}}
            {{/functions}}
        </script>

        <div class="nav-item dropleft">
            <a class="nav-link dropdown-alarm" href="#" id="dropdown04" style="color:white"
               data-toggle="dropdown"
               aria-haspopup="false" aria-expanded="false">
                <i class="far fa-bell fa-2x" id="alarm_icon"></i>
            </a>
            <div class="dropdown-menu alarm-items" aria-labelledby="dropdown04">
                <button type="button" style="float: right" class="btn-alarm-delete-all">모두 삭제
                </button>
                <br><br>
                <div id="alarmcontent">
                </div>
            </div>
        </div>
        <script id="alarm-count-template" type="text/x-handlebars-template">
            <button type="button btn-alarm-count" id="alarmCount">{{alarmCount}}</button>
        </script>
        <script id="alarmList-template" type="text/x-handlebars-template">
            {{#alarms}}
                <div>
                    <li class="dropdown-item">
                        <button type="button" class="btn-alarm-delete">X</button>
                        <a href="/alarms/{{alarmID}}" data-id="{{alarmID}}" target="_self"
                           class="alarm-item">
                            {{userName}}님이
                            {{#isPostAlarm}}
                                게시글에서 회원님을 언급했습니다.
                            {{else}}
                                댓글에서 회원님을 언급했습니다:<br>
                                {{alarmContent}}
                            {{/isPostAlarm}}
                            <span style="float: right">{{registerTime}}</span>
                        </a>

                    </li>
                </div>
            {{/alarms}}
        </script>
        <a class="nav-link text-white" id="current_user_info" style="nav-right: auto"
           data-id="${userID}" data-type="${userType}">${userName}</a>
        <a class="nav-link text-white" style="nav-right: auto"
           href="<c:url value='/logout' />">로그아웃</a>
    </div>
</nav>
<div class="row">
    <br>
</div>
<div class="container-fluid row-cols-1">

    <div class="row bg-success text-white">
    </div>
    <div class="row">
        <div class="col-2">
            <ul class="tab" id="tab_id">
            </ul>
            <!--게시판 목록 템플릿-->
            <script id="boards-template" type="text/x-handlebars-template">
                <li data-tab="-5" class="tabmenu" id=default style="cursor:pointer"> 최신 게시글</li>
                <li data-tab="-6" class=tabmenu id=default style="cursor:pointer"> 인기게시글</li>
                <li data-tab="-1" class="tabmenu" id=default style="cursor:pointer"> 내가 쓴 글</li>
                <li data-tab="-2" class="tabmenu" id=default style="cursor:pointer"> 내가 쓴 댓글</li>
                <hr>
                {{#boards}}
                    <li data-tab={{boardID}} class=tabmenu id=default style="cursor:pointer">
                        {{boardName}}
                    </li>
                {{/boards}}
                <hr>
                {{#isTempSaveAble}}
                    <li data-tab="-3" class=tabmenu id=default style="cursor:pointer"> 임시보관함</li>
                {{/isTempSaveAble}}
                <li data-tab="-4" class=tabmenu id=default style="cursor:pointer"> 휴지통</li>
            </script>
        </div>
        <div class="border-left border-success col">
            <!-- 태그 이름 클릭 -> 회원 정보 Modal -->
            <div class="modal" id="tagUserInfoModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title text-success">회원 정보</h5>
                            <button type="button" class="close" data-dismiss="modal"
                                    aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body-userInfo" style="padding: 15px 10px 10px 10px">
                            <div class="row">
                                <div class="col">
                                    <img id="modal_userImage" width="100">
                                </div>
                                <div class="col">
                                    <p>회원 이름: <a id="modal_userName">전우혁</a></p>
                                    <p>회원 ID : <a id="modal_userID"></a></p>
                                    <p>회원 유형: <a id="modal_userType"></a></p>
                                    <p>회사명 : <a id="modal_companyName"></a></p>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                닫기
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 게시판 추가 Modal -->
            <div class="modal" id="addBoardModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title text-success">게시판 추가</h5>
                            <button type="button" class="close" data-dismiss="modal"
                                    aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body-addboard">
                            <p style="padding: 15px 1px 5px 10px;">
                                <a>입력 </a>
                                <input type="text" name="게시판 이름" id="input_board_name"
                                       class="addBoard"
                                       placeholder="게시판 이름">
                                <span id="board_name_length"></span>
                            </p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                Close
                            </button>
                            <button type="button" id='add_board_save_btn' class="btn btn-success"
                                    data-dismiss="modal">Save changes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 게시판 삭제 Modal -->
            <div class="modal" id="deleteBoardModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title text-success">삭제할 게시판을 선택하시오.</h5>
                            <button type="button" class="close" data-dismiss="modal"
                                    aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body-deleteBoard">

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                Close
                            </button>
                            <button type="button" id='deleteBoardBtn' class="btn btn-success"
                                    onclick=javascript:clickSaveDelteBoard(this)
                                    data-dismiss="modal">Save changes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <!--게시판 삭제 템플릿-->
            <script id="deleteboards-template" type="text/x-handlebars-template">
                {{#boards}}

                    <div class="custom-control custom-checkbox checkbox-success"
                         style="padding: 15px 1px 10px 30px;">
                        <input class="custom-control-input" type='checkbox' name='boardDelete'
                               id="checkDelBoard{{boardID}}" value='{{boardID}}'/>
                        <label class="custom-control-label"
                               for="checkDelBoard{{boardID}}">{{boardName}}</label>
                    </div>
                {{/boards}}
            </script>
            <!-- 게시판 이름변경 Modal -->
            <div class="modal" id="changeBoardNameModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title text-success">게시판 이름 변경</h5>
                            <button type="button" class="close" data-dismiss="modal"
                                    aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body-changeBoardName">

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                Close
                            </button>
                            <button type="button" id='changeNameBtn' class="btn btn-success"
                                    onclick=javascript:clickSaveChangeBoard(this)
                                    data-dismiss="modal">Save changes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <!--게시판 이름변경 템플릿-->
            <script id="changeBoardName-template" type="text/x-handlebars-template">
                {{#boards}}
                    <div class='boardInfo' id='board{{boardID}}'
                         style="padding: 15px 1px 5px 10px;">
                        <span class='deleteBoard'
                              data-board='board{{boardID}}'> {{boardName}} </span>
                        <span class="glyphicon glyphicon-arrow-right" aria-hidden="true"></span>
                        <input class="form-control" type='text' name='boardname'
                               data-boardid={{boardID}} data-oldname="{{boardName}}"
                               value="{{boardName}}">
                    </div>
                {{/boards}}
            </script>
            <!-- 기능변경 Modal -->
            <div class="modal" id="changeFunctionModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title text-success">기능 변경</h5>
                            <button type="button" class="close" data-dismiss="modal"
                                    aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <ul class="modal-body-changeFunctions" style="list-style:none;">

                        </ul>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                Close
                            </button>
                            <button type="button" id='changeFunction' class="btn btn-success"
                                    onclick=javascript:clickSaveFunctionChange(this)
                                    data-dismiss="modal">Save changes
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <!--기능변경 템플릿-->
            <script id="changeFunctionInfo-template" type="text/x-handlebars-template">
                {{#functions}}
                    {{#isAbleFunction}}
                        <li class="btn-group-toggle {{isCommentFunction}}" data-toggle="buttons"
                             style="padding: 3px 1px 1px 10px;">
                            <label class="btn btn-default _function-switch">
                                <span>{{functionName}}</span>
                                <input class='function_checkbox' type='checkbox' name='function'
                                       value={{functionID}}>
                                <span class='_switch'>OFF</span>
                            </label>
                        </li>
                    {{else}}
                        <li class="btn-group-toggle {{isCommentFunction}}" data-toggle="buttons"
                             style="padding: 3px 1px 1px 10px;">
                            <label class="btn btn-success _function-switch">
                                <span>{{functionName}}</span>
                                <input class='function_checkbox' type='checkbox' name='function'
                                       value={{functionID}} checked>
                                <span class='_switch'>ON</span>
                            </label>
                        </li>
                    {{/isAbleFunction}}
                {{/functions}}
            </script>
            <!-- 회원 추가 Modal -->
            <div class="modal" id="addUserModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title text-success">회원 추가</h5>
                            <button type="button" class="close" data-dismiss="modal"
                                    aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body-addUser">
                            <form id="userForm" name="userForm" method="post" class="form-group"
                                  style="padding: 10px 30px 10px 10px;">
                                <label class="col-form-label">회원 ID (최대 20자)</label>
                                <input type="text" class="form-control" name="userID"
                                       placeholder="회원 ID (최대 20자)" maxlength="20">
                                <label class="col-form-label">회원 이름</label>
                                <input type="text" class="form-control" name="userName"
                                       placeholder="회원 이름">
                                <label class="col-form-label">회원 초기 비밀번호</label>
                                <input type="text" class="form-control" name="userPassword"
                                       placeholder="회원 초기 비밀번호">
                                <label class="col-form-label">회원 사진</label>
                                <input type="file" class="form-control" name="userImageFile"
                                       id="userImageFile"
                                       accept="image/png, image/jpeg" onchange="loadImage(this)">
                                <img id="load_user_image" height="300px">
                                <input type="button" class="form-control btn-success"
                                       value="Add User" onclick="addUser(); return false">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!--게시글 작성 폼-->
            <div id="writecontent" style="display:none">
                <!--게시글 작성 시 게시판 선택 폼-->
                <div class="form-group row">
                    <div class="col-sm-2">
                        <label class="font-weight-light"> 게시판 선택 </label>
                    </div>
                    <div class="col-2 d-flex">
                        <select class="form-control-sm" id="selectedBoardIDinEditor">
                        </select>
                    </div>
                    <!--게시글 작성 시 게시판 목록 템플릿-->
                    <script id="writecontent-boards-template" type="text/x-handlebars-template">
                        {{#boards}}
                            <option data-tab={{boardID}} class=tabmenu
                                    id=default>{{boardName}}
                            </option>
                        {{/boards}}
                    </script>
                </div>
                <!--에디터 폼-->
                <div class="form-group row">
                    <div class="col-2">
                        <label class="font-weight-light">게시글 제목</label>
                    </div>
                    <div class="col-6">
                        <input type="text" class="form-control" id="post_title"/>
                    </div>
                </div>
                <!--파일추가 폼-->
                <div class="form-group row file_attach_form">
                </div>
                <script id="file-attach-form-template" type="text/x-handlebars-template">
                    <div class="col-2">
                        <label class="font-weight-light">파일첨부</label>
                        <a class='file_drag_and_drop_btn text-success font-weight-bold text-button'
                           style="cursor: pointer; margin-left: 5px">열기</a>
                    </div>
                    <div class="col-10">
                        <form name="uploadForm" class="uploadForm" enctype="multipart/form-data"
                              method="post">
                            <div class="upload_list_start_point"></div>
                            <div class=file_drop_container></div>

                        </form>

                    </div>

                </script>
                <script id="file-attach-drag-and-drop-form-template"
                        type="text/x-handlebars-template">
                    <div class="dragAndDropDiv dragAndDropBox">
                        파일을 드래그 하세요
                    </div>
                </script>


                <div id="editorcontent" class="form-group"></div>
                <script id="editorcontent-template" type="text/x-handlebars-template">
                    <textarea id="editor"></textarea>
                    <button class="btn btn-success btn_post">저장</button>
                    <button class="btn btn-success btn_cancel">작성취소</button>
                    {{#isTempSaveAble}}
                        <button class="btn btn-success btn_tempSave">임시저장</button>
                    {{/isTempSaveAble}}
                    <div id="editorcontent-hidden"></div>
                </script>
                <script id="postid-template" type="text/x-handlebars-template">
                    <a id="postIdInEditor" style="display:none">{{postID}}</a>
                    <a id="boardIdInEditor" style="display:none">{{boardID}}</a>
                </script>
            </div>

            <div id="postcontent" class="border-primary"></div>
            <!--게시물 내용 템플릿-->
            <script id="postcontent-template" type="text/x-handlebars-template">
                {{#post}}
                    <p class="h4">{{postTitle}}</p>
                    <p class="h6 writer_info" align="right" data-id="{{userID}}">{{userName}}</p>
                    <p class="h6" align="right">{{postRegisterTime}}</p>
                    <p align="right"><a class="h6 read_check" data-toggle="modal" data-target="#check_read_user" align="right">읽음 {{viewCount}}</a></p>
                    <hr>
                    <div class="attached_file_list_container_post">
                        <!--첨부파일 컨테이너 -->
                    </div>

                    <div class="d-block">
                        <p>{{{postContent}}}</p>
                    </div>
                    <a id="postID" style="visibility: hidden;">{{postID}}</a>
                    <a id="boardIdInPost" style="visibility: hidden">{{boardID}}</a>
                    <br>
                    <button class="btn btn-success btn_modify" style="visibility:hidden">수정</button>
                    <button class="btn btn-success btn_delete" style="visibility:hidden">삭제</button>
                {{/post}}

                {{#isCommentAble}}
                    <div class=comment_section>
                        <br><br>
                        <div class="row">
                        <span class="col-2">
                            <strong class="c">댓글 </strong>
                        (<span id=commentCount></span>)
                        </span>
                            <a class=' commentBtn text-success font-weight-bold text-button'
                            >댓글 달기</a>
                        </div>
                        <div class=comment_list_container></div>
                        <div class=comment_input_container></div>
                {{else}}
                    </div>
                {{/isCommentAble}}
            </script>

            <!--기독 모달-->
            <div class="modal" id="check_read_user" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title text-success">게시글 조회 유저 확인</h5>
                            <button type="button" class="close" data-dismiss="modal"
                                    aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <ul class="modal-body-viewRecordList-container" style="list-style:none;">
                            <!--사용자 목록-->
                        </ul>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                Close
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <!--기독 리스트 템플릿-->
            <script id="view_record-list-template" type="text/x-handlebars-template">
                {{#records}}
                    <li>
                        <div class ="row">
                            <div class="col-1">
                                <img class = "profile" name ="profile" width="50px" height="50px" src='{{thumbnailUrl}}'>
                            </div>
                            <div class="col">
                                <a style="padding-left: 30px; padding-top: 15px"><strong class=name
                                           data-id='{{userID}}'>{{userName}}</strong>({{userID}})</a>
                            </div>
                        </div>
                    </li>
                {{/records}}
            </script>
            <!--첨부파일 리스트 템플릿-->
            <script id="attached-file-list-template" type="text/x-handlebars-template">
                <a class='text-success font-weight-bold'>첨부파일</a>
                {{#files}}
                    <div class="form-group">
                        <p><a class="attached-file-download" data-fileid='{{fileID}}'
                              href="/files/{{fileID}}">{{originFileName}} ( {{printFileSize}} )</a>
                        </p>
                    </div>

                {{/files}}
                <hr>
            </script>
            <!--statusbar 템플릿-->
            <script id="attached-file-statusbar-template" type="text/x-handlebars-template">
                {{#files}}
                    <div class="statusbar">
                        <div class="filename"
                             data-filename='{{storedFileName}}'>{{originFileName}}
                        </div>
                        <div class="filesize">{{fileSize}}</div>
                        <div class="progressBar">
                            <div style="width: 199px;">100%</div>
                        </div>
                        <div class="abort" style="display: none;">중지</div>
                        <a class="delete-statusbar file_upload_btn text-success font-weight-bold text-button">삭제</a>
                    </div>
                {{/files}}
            </script>
            <!--댓글리스트 템플릿-->
            <script id="commentList-template" type="text/x-handlebars-template">
                {{#comments}}
                    <hr>
                    <div class='referenceCommentContainer ' data-id='{{commentID}}'>

                        <div class="row border-left-comment localCommentContainer">
                            <div class="col-1">
                                <img class = "profile" name ="profile" width="75px" height="75px" src='{{thumbnailUrl}}'>
                            </div>
                            <div class='commentContainer col-8' id='comment{{commentID}}'
                                 style="padding-left: 50px">
                                <div class="user"><h5><strong class=name
                                                              data-id={{userID}}>{{userName}}</strong>
                                </h5></div>
                                <div>
                                    <div>
                                        <div class="comment_area comment_content" id=translate_area
                                             style="width: 100%;">{{{commentContent}}}
                                        </div>
                                        <br>
                                        <div class="date text-muted">{{commentRegisterTime}}</div>
                                    </div>
                                    <div class="btn">
                                        {{#isReplyAble}}
                                            <a class='text-success text-button font-weight-bold replyBtn'>답글</a>
                                        {{else}}
                                        {{/isReplyAble}}

                                        {{#isSameUser}}
                                            <a class="text-success text-button font-weight-bold"
                                               id='edit_comment'>수정</a>
                                            <a class="text-success text-button font-weight-bold"
                                               id='delete_comment'>삭제</a>
                                        {{else}}
                                        {{/isSameUser}}
                                        {{#isCommentFileAttachAble}}
                                            <a class="text-success text-button font-weight-bold open_attached_file_list"
                                            >첨부파일 보기</a>
                                        {{else}}
                                        {{/isCommentFileAttachAble}}
                                    </div>
                                </div>
                            </div>
                            <div class="col-3 attached_file_list_container_comment">
                            </div>
                        </div>
                        {{#isReplyAble}}
                            <div class='replyContainer' id='reply_container{{commentID}}'
                                 style='padding: 5px 1px 3px 30px;'>
                            </div>
                            <div id='reply_input_container{{commentID}}'
                                 style='padding: 5px 1px 3px 30px;'></div>
                        {{else}}
                        {{/isReplyAble}}
                        <div>

                        </div>
                    </div>
                {{/comments}}
            </script>
            <!--답글 List 템플릿-->
            <script id="replyList-template" type="text/x-handlebars-template">
                {{#replies}}
                    <hr>
                    <div class='row localCommentContainer'>
                        <div class="col-1">
                        </div>
                        <div class="col-1" style="padding-right: 10px">
                            <img class = "profile" name ="profile" width="75px" height="75px" src='{{thumbnailUrl}}'>
                        </div>
                        <div class='commentContainer col-7' id='comment{{commentID}}' style="padding-left: 30px">
                            <div class="user"><h5><strong class=name
                                                          data-id={{userID}}>{{userName}}</strong>
                            </h5>
                            </div>
                            <div>
                                <div class="comment_area row" id=translate_area">
                                    <strong class="nametag text-primary "
                                            data-id={{commentReferencedUserID}}
                                            style="cursor:pointer;padding: 0px 0px 0px 15px">{{commentReferencedUserName}}</strong>
                                    <div class="comment_content col-10" style="float:left;">
                                        {{{commentContent}}}
                                    </div>
                                </div>
                                <br>
                                <div class="date text-muted">{{commentRegisterTime}}</div>
                            </div>
                            <div class=btn>
                                {{#isReplyAble}}
                                    <a class='text-success text-button font-weight-bold replyBtn'
                                    >답글</a>
                                {{else}}
                                {{/isReplyAble}}
                                {{#isSameUser}}
                                    <a class="text-success text-button font-weight-bold"
                                       id='edit_comment'
                                    >수정</a>
                                    <a class="text-success text-button font-weight-bold"
                                       id='delete_comment'
                                    >삭제</a>
                                {{else}}
                                {{/isSameUser}}
                                {{#isCommentFileAttachAble}}
                                    <a class="text-success text-button font-weight-bold open_attached_file_list"
                                    >첨부파일 보기</a>
                                {{else}}
                                {{/isCommentFileAttachAble}}
                            </div>
                        </div>
                        <div class="col-3 attached_file_list_container_comment">
                        </div>
                    </div>
                {{/replies}}
                <div>
                </div>
            </script>
            <!--댓글 답글 input form 템플릿-->
            <script id="commentInputForm-template" type="text/x-handlebars-template">
                {{#attribute}}
                    <br>
                    <div style='width: 100%' class='commentHtml {{isReplyInput}}'>
                        <textarea class="form-control" id=commentText placeholder='{{type}}을 입력하세요'
                                  name=commentTxt></textarea>
                        <div class="form-group row file_attach_form">
                        </div>
                        <div align="right">
                            {{#isCommentFileAttachAble}}
                                <a class="text-success text-button font-weight-bold open_file_form_btn"
                                >파일첨부</a>
                            {{else}}
                            {{/isCommentFileAttachAble}}
                            {{#isReply}}
                                <a class="text-success text-button font-weight-bold {{{buttonSelector}}}"
                                >{{buttonName}}</a>
                                <a class="btn_close_cmt_input text-success text-button font-weight-bold"
                                >취소</a>
                            {{else}}
                                <a class="text-success text-button font-weight-bold {{{buttonSelector}}}"
                                >{{buttonName}}</a>
                            {{/isReply}}
                        </div>
                    </div>

                {{/attribute}}
            </script>
            <!--댓글 수정 템플릿-->
            <script id="editCommentForm-template" type="text/x-handlebars-template">
                {{#attribute}}
                    <br>
                    <div style='width: 100%' class=commentHtml>
                <textarea class="form-control" style='width: 100%' id='commentText'
                          placeholder='댓글을 입력하세요'
                          name=commentTxt>{{{oldText}}}</textarea>
                        <div>
                            <div class="form-group row file_attach_form">
                            </div>
                            <div align="right">
                                {{#isCommentFileAttachAble}}
                                    <a class="text-success text-button font-weight-bold open_edit_file_form_btn"
                                    >파일첨부 수정</a>
                                {{else}}
                                {{/isCommentFileAttachAble}}
                                <a class="text-success text-button font-weight-bold btn_edit_comment_complete"
                                >수정하기</a>
                            </div>

                        </div>
                    </div>
                {{/attribute}}
            </script>

            <div id="tabcontent" class="container-fluid">
                <table id="post_table" class="table table-hover" cellpadding="0" cellspacing="0"
                       border="0"></table>
                <!--게시글 목록 템플릿-->
                <script id="posts-template" type="text/x-handlebars-template">
                    <thead>
                    <tr>
                        {{#isPopular}}
                            <th scope="col">게시판</th>
                        {{else}}
                        {{/isPopular}}
                        <th scope="col">제목</th>
                        <th scope="col">작성자</th>
                        <th scope="col">작성일</th>
                        {{#isTempBox}}
                        {{else}}
                            {{#isRecycleBin}}
                            {{else}}
                                <th scope="col">조회수</th>
                            {{/isRecycleBin}}
                        {{/isTempBox}}
                    </tr>
                    </thead>
                    <tbody id="postlist">
                    {{#posts}}
                        {{#isTemp}}
                            <tr class="postclick temp_post_click" data-post={{postID}}
                                data-board={{boardID}}>
                                <td>{{boardName}}</td>
                                <td>{{postTitle}}</td>
                        {{else}}
                            {{#isRecycle}}
                                <tr class="postclick recycle_post_click" data-post={{postID}}
                                    data-board={{boardID}}>
                                    <td>{{boardName}}</td>
                                    <td>{{postTitle}}</td>
                            {{else}}
                                <tr class="postclick normal_post_click" data-post={{postID}}
                                    data-board={{boardID}}>
                                {{#isPopular}}
                                        <td>{{boardName}}</td>
                                {{else}}
                                {{/isPopular}}
                                    <td>{{postTitle}}
                                        {{#isCommentAble}}
                                            <span style="color:#28A745;">({{commentsCount}})</span>
                                        {{/isCommentAble}}
                                    </td>
                            {{/isRecycle}}
                        {{/isTemp}}
                            <td>{{userName}}</td>
                            <td>{{postRegisterTime}}</td>
                        {{#isTemp}}
                        {{else}}
                            {{#isRecycle}}
                            {{else}}
                                    <td>{{viewCount}}</td>
                            {{/isRecycle}}
                        {{/isTemp}}
                        </tr>
                    {{/posts}}
                </script>

                <script id="empty-posts-template" type="text/x-handlebars-template">
                    <h3 style="text-align: center">표시할 게시글이 없습니다.</h3>
                </script>
                </table>

                <div id="searchcontent">
                    <div class="form-group row">
                        <div class="col-sm-1">
                            <select id="search_option" class="form-control"
                                    style="width:100px;font-size:15px;">
                                <option value="title">제목</option>
                                <option value="writer">작성자</option>
                                <option value="content">내용</option>
                                <option value="titleAndContent">제목+내용</option>
                            </select>
                        </div>
                        <div class="col-5">
                            <input id="search_keyword" class="form-control"
                                   placeholder="검색어를 입력하세요." type="text"/>
                        </div>
                        <div class="col-3">
                            <button id="search" class="btn btn-success"
                                    onclick="javascript:search(this)">조회
                            </button>
                        </div>
                        <div class="col">
                            <button id="btn_write" class="btn btn-success" style="float:right">글쓰기
                            </button>
                        </div>
                    </div>

                </div>
                <div class="pagination_container">
                    <nav aria-label="Page navigation example">
                        <ul class="pagination" id="pagination_content">

                        </ul>
                    </nav>
                </div>
                <!--게시판 페이징 템픞릿-->
                <script id="pageList-template" type="text/x-handlebars-template">
                    {{#pagesInfo}}
                        {{#isFirstPage}}
                        {{else}}
                            <li class="page-item"><a class="page-link"
                                                     style="cursor: pointer;" data-page="1">처음</a>
                            </li>
                        {{/isFirstPage}}
                        {{#isFirstRange}}
                        {{else}}
                            <li class="page-item"><a class="page-link" style="cursor: pointer;"
                                                     data-page='{{prevPage}}'>이전</a></li>
                        {{/isFirstRange}}
                        {{#each pageList}}
                            <li class="page-item" id="page{{this}}"><a class="page-link page-index"
                                                                       style="cursor: pointer;"
                                                                       data-page='{{this}}'>{{this}}</a>
                            </li>
                        {{/each}}
                        {{#isLastRange}}
                        {{else}}
                            <li class="page-item"><a class="page-link" style="cursor: pointer;"
                                                     data-page='{{nextPage}}'>다음</a></li>
                        {{/isLastRange}}
                        {{#isLastPage}}
                        {{else}}
                            <li class="page-item"><a class="page-link" style="cursor: pointer;"
                                                     data-page='{{pageCount}}'>마지막</a></li>
                        {{/isLastPage}}
                    {{/pagesInfo}}
                </script>

            </div>
        </div>
    </div>
</div>

<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<script src="/webjars/bootstrap/4.4.1/dist/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="https://cdn.jsdelivr.net/npm/handlebars@latest/dist/handlebars.js"></script>
<script src="/static/js/event/boardEvent.js"></script>
<script src="/static/js/event/postEvent.js"></script>
<script src="/static/js/event/commentEvent.js"></script>
<script src="/static/js/event/functionEvent.js"></script>
<script src="/static/js/event/paginationEvent.js"></script>
<script src="/static/js/event/alarmEvent.js"></script>
<script src="/static/js/event/common.js"></script>
<script src="/static/js/event/mentionEvent.js"></script>
<script src="/static/js/event/fileEvent.js"></script>
<script src="/static/js/event/viewRecordEvent.js"></script>
<script src="/static/js/ajax/functionAjax.js"></script>
<script src="/static/js/ajax/commentAjax.js"></script>
<script src="/static/js/ajax/postAjax.js"></script>
<script src="/static/js/ajax/boardAjax.js"></script>
<script src="/static/js/ajax/paginationAjax.js"></script>
<script src="/static/js/ajax/fileAjax.js"></script>
<script src="/static/js/ajax/userAjax.js"></script>
<script src="/static/js/ajax/alarmAjax.js"></script>
<script src="/static/js/ajax/viewRecordAjax.js"></script>
<script src="/static/ckeditor/ckeditor.js"></script>
<script src="/static/ckeditor/adapters/jquery.js"></script>
<script src="/static/js/util/handlebarsHelper.js"></script>
<script src="/static/js/util/file.js"></script>
<script src="/static/js/updateUI/boardUI.js"></script>
<script src="/static/js/updateUI/commentUI.js"></script>
<script src="/static/js/updateUI/functionUI.js"></script>
<script src="/static/js/updateUI/paginationUI.js"></script>
<script src="/static/js/updateUI/viewRecordUI.js"></script>
<script src="/static/js/updateUI/postUI.js"></script>
<script src="/static/js/updateUI/fileUI.js"></script>
<script src="/static/js/updateUI/alarmUI.js"></script>
<script src="/static/js/util/windowLoad.js"></script>

</body>

</html>