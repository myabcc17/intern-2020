/**
 * @author Dongwook Kim <dongwook.kim1211@worksmobile.com>
 * @file CommentController.java
 */
package com.board.project.blockboard.controller;

import com.board.project.blockboard.dto.CommentDTO;
import com.board.project.blockboard.dto.UserDTO;
import com.board.project.blockboard.service.CommentService;
import com.board.project.blockboard.service.JwtService;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/boards/{boardid}/posts/{postid}/comments")
public class CommentController {

  @Autowired
  private CommentService commentService;
  @Autowired
  private JwtService jwtService;

  /**
   * postID 일치하는 댓글 목록 리턴 ( 대댓글은 반환하지 않는다.)
   */
  @GetMapping("")
  public List<CommentDTO> getCommentsByPost(@PathVariable("postid") int postID) {
    List<CommentDTO> commentList = commentService.getCommentListByPostID(postID);
    return commentList;
  }

  /**
   * 게시물 별로 댓글 개수를 반환한다.
   * @param postID 게시물의 ID
   * @return 댓글개수를 반환
   */
  @GetMapping("/counts")
  public int getCommentsCountSByPostID(@PathVariable("postid") int postID,HttpServletRequest request) {
    UserDTO userData = new UserDTO(request);
    int commentCount = commentService.getCommentCountByPostID(postID,userData.getCompanyID());
    return commentCount;
  }

  /**
   * 댓글 추가
   */
  @PostMapping("")
  public void writeComment(@RequestParam("postID") int postID,
      @RequestParam("commentContent") String commentContent, HttpServletRequest request) {
    UserDTO useeData = new UserDTO(request);
    commentService.writeCommentWithUserInfo(useeData.getUserID(), commentContent, useeData.getCompanyID(), postID);
  }

  /**
   * 댓글 삭제
   */
  @DeleteMapping("/{commentid}")
  public void deleteComment(@PathVariable("commentid") int commentID,
      @PathVariable("postid") int postID) {
    commentService.deleteComment(commentID);
  }

  /**
   * 댓글 수정하기
   *
   * @param newComment 변경된 새로운 내용
   */
  @PutMapping("/{commentid}")
  public void editComment(@PathVariable("commentid") int commentID,
      @PathVariable("postid") int postID, @PathVariable("boardid") int boardID,
      @RequestParam("newComment") String newComment) {
    commentService.updateComment(commentID, newComment);
  }
}
