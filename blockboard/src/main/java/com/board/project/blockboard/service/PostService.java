/**
 * @author Woohyeok Jun <woohyeok.jun@worksmobile.com>
 * @file PostService.java
 */
package com.board.project.blockboard.service;

import com.board.project.blockboard.common.constant.ConstantData;
import com.board.project.blockboard.common.util.JsonParse;
import com.board.project.blockboard.dto.PaginationDTO;
import com.board.project.blockboard.dto.PostDTO;
import com.board.project.blockboard.dto.UserDTO;
import com.board.project.blockboard.mapper.PostMapper;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class PostService {

  @Autowired
  private PostMapper postMapper;
  @Autowired
  private CommentService commentService;

  public void insertPost(PostDTO post) {
    postMapper.insertPost(post);
  }

  public void deletePost(int postID) {
    postMapper.deletePostByPostID(postID);
  }

  public PostDTO selectPostByPostID(int postID) {
    updateViewCnt(postID);
    return postMapper.selectPostByPostID(postID);
  }

  public void updatePost(PostDTO post) {
    postMapper.updatePost(post);
  }

  public List<PostDTO> searchPost(String option, String keyword) {
    return postMapper.searchPost(option, keyword);
  }

  public PostDTO selectRecentTemp(UserDTO requestUser) {
    return postMapper.selectRecentTempPost(requestUser);
  }

  public List<PostDTO> getTempPosts(UserDTO userDTO) {
    return postMapper.selectTempPosts(userDTO);
  }

  public PostDTO selectTempPost(int postID) {
    return postMapper.selectPostByPostID(postID);
  }

  public void movePostToTrash(PostDTO post) {
    postMapper.temporaryDeletePost(post);
  }

  public List<PostDTO> getPostsInTrashBox(UserDTO requestUser) {
    return postMapper.selectPostsInTrashBox(requestUser);
  }

  public void restorePost(PostDTO post) {
    postMapper.restorePost(post);
  }

  public void setPostStatusIsTempAndIsTrash(PostDTO post, boolean isTemp, boolean isTrash) {
    Map<String, Object> statusMap = new HashMap<>();
    statusMap.put("isTemp", isTemp);
    statusMap.put("isTrash", isTrash);

    JSONObject statusJson = JsonParse.getJsonStringFromMap(statusMap);
    post.setPostStatus(statusJson.toJSONString());
  }

  /**
   * 게시판 번호와 페이지번호를 가지고 출력할 게시물 목록 반환
   * @author Dongwook Kim <dongwook.kim1211@worksmobile.com>
   */
  public List<PostDTO> getPostListByBoardID(int boardID, int pageNumber,int companyID) {
    int pageCount = getPostsCountByBoardID(boardID);
    PaginationDTO pageInfo = new PaginationDTO(pageCount, pageNumber, ConstantData.PAGE_SIZE,
        ConstantData.RANGE_SIZE);
    List<PostDTO> postList = postMapper
        .selectPostByBoardID(boardID, pageInfo.getStartIndex(), ConstantData.PAGE_SIZE);

    //댓글수 update
    for(PostDTO post : postList){
      int commentsCount = commentService.getCommentCountByPostID(post.getPostID(),companyID);
      post.setCommentsCount(commentsCount);
    }

    return postList;
  }

  /**
   * 게시물 출력에 필요한 정보를 추가한다. 댓글수
   * @author Dongwook Kim <dongwook.kim1211@worksmobile.com>
   */
  private List<PostDTO> updatePostInfo(List<PostDTO> postList,int companyID) {

    return postList;
  }

  /**
   * @author Dongwook Kim <dongwook.kim1211@worksmobile.com>
   */
  public PostDTO getPostByPostID(int postID) {
    PostDTO post = postMapper.selectPostByPostID(postID);
    return post;
  }

  /**
   * @author Dongwook Kim <dongwook.kim1211@worksmobile.com>
   */
  public int getPostsCountByBoardID(int boardID) {
    int postCounts = postMapper.selectPostCountByBoardID(boardID);
    return postCounts;
  }

  public void updateViewCnt(int postID){
     postMapper.updateViewCnt(postID);
  }
}

