/**
 * @author Dongwook Kim <dongwook.kim1211@worksmobile.com>
 * @file CommentService.java
 */
package com.board.project.blockboard.service;

import com.board.project.blockboard.common.constant.ConstantData.PageSize;
import com.board.project.blockboard.common.constant.ConstantData.RangeSize;
import com.board.project.blockboard.dto.CommentDTO;
import com.board.project.blockboard.dto.PaginationDTO;
import com.board.project.blockboard.mapper.CommentMapper;
import com.board.project.blockboard.mapper.UserMapper;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.Jsoup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class CommentService {

  @Autowired
  private FunctionService functionService;
  @Autowired
  private AlarmService alarmService;
  @Autowired
  private CommentMapper commentMapper;
  @Autowired
  private UserMapper userMapper;
  @Autowired PostService postService;


  public List<CommentDTO> getCommentListByPostId(int postId,int pageNumber) {
    int pageCount = postService.getCommentsCountByPostId(postId);
    PaginationDTO pageInfo = new PaginationDTO("comments",pageCount,pageNumber,
        PageSize.COMMENT, RangeSize.COMMENT);
    return commentMapper.selectCommentsByPostId(postId,pageInfo.getStartIndex(),PageSize.COMMENT);
  }

  //TODO 카운트는 비동기로 트랜잭션 처리보다야
  public int writeCommentWithUserInfo(CommentDTO commentData, String userId, int companyId) {
    updateCommentData(commentData, userId, companyId);

    commentMapper.insertNewCommentByCommentInfo(commentData);
    postService.updateCommentCountPlus1(commentData.getPostId());
    alarmService.insertAlarm(commentData);
    return commentData.getCommentId();
  }



  //TODO 카운트는 비동기로 트랜잭션 처리보다야
  //
  public void deleteComment(int commentId) {
    int postId = postService.getPostIdByCommentId(commentId);
    Integer commentReferencedId = commentMapper.selectCommentReferencedIdByCommentId(commentId);
    commentMapper.deleteCommentByCommentReferencedId(commentId);
    commentMapper.deleteCommentByCommentId(commentId);
    updateCountMinus1(postId, commentReferencedId);

  }

  public void updateCountMinus1(int postId, Integer commentReferencedId) {
    if(commentReferencedId!=null){//답글일때
      updateRepliesCountMinus1(commentReferencedId);
    } else{//댓글일때
      postService.updateCommentCountMinus1(postId);
    }
  }

  public void updateComment(CommentDTO commentData) {
    commentData.setCommentContentExceptHTMLTag( Jsoup.parse(commentData.getCommentContent()).text());
    commentMapper.updateComment(commentData);
  }

  public void updateRepliesCountPlus1(int commentId) {
    commentMapper.updateRepliesCountPlus1(commentId);
  }
  private void updateRepliesCountMinus1(int commentReferencedId) {
    commentMapper.updateRepliesCountMinus1(commentReferencedId);
  }


  public int getRepliesCountByCommentReferencedId(int commentReferencedId) {
    Integer count = commentMapper.selectRepliesCountByCommentReferencedId(commentReferencedId);
    if (count == null)
      return 0;
    return count;
  }

  public CommentDTO selectCommentByCommentId(int commentId) {
    return commentMapper.selectCommentByCommentId(commentId);
  }

  private void updateCommentData(CommentDTO commentData, String userId, int companyId) {
    commentData.setCommentContentExceptHTMLTag(Jsoup.parse(commentData.getCommentContent()).text());
    commentData.setUserName(userMapper.selectUserNameByUserId(userId));
    commentData.setUserId(userId);
    commentData.setCompanyId(companyId);
  }
}
