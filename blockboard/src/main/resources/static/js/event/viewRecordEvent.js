/**
 * @author  Woohyeok Jun <woohyeok.jun@worksmobile.com>
 * @file    viewRecordEvent.js
 */

var hasRemainData;
$(document).on("click", ".read_check", function () {
  var postId = getPostIdInPost();
  var boardId = getBoardIdInPost();
  $('.modal-body-viewRecordList-container').html("");
  hasRemainData=true;
  getViewRecords(postId,boardId,0,loadViewRecordUI);
  //안띄움

});
$('.modal-read-user-container').on("scroll",function () {
  var scrollTop = $(this).scrollTop();
  var innerHeight = $(this).innerHeight();
  var scrollHeight = $(this).prop('scrollHeight');
  var resultCount =  $(".view_record_data").length;
  var postId = getPostIdInPost();
  var boardId = getBoardIdInPost();
  if (scrollTop + innerHeight >= scrollHeight-0.25 && hasRemainData){
    console.log(scrollTop + innerHeight-scrollHeight);
    getViewRecords(postId,boardId,resultCount,loadViewRecordUI);
  }
});


function isWriter(){
  var writerId = getWriterId($(this));
  var user = new User();
  if(user.getUserId ==writerId){
    return true;
  }else{
    return false;
  }

}

function getWriterId(obj){
  return obj.closest('.postcontent').find('.writer_info').attr("data-id");

}
